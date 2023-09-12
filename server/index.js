const express = require("express");
const userRoutes = require("./src/user/routes");

const PORT = process.env.PORT | 3001;
const app = express();

app.use(express.json());

app.get("/", (req, res) => {
    res.send(`Nyambung ke ${PORT}`);
});

app.use("/api/v1/user", userRoutes);

app.listen(PORT, "0.0.0.0", () => {
    console.log(`connected at port ${PORT}`);
});