From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Thu, 14 Jun 2012 19:24:02 +0300
Message-ID: <1339691042.2401.217.camel@sauron.fi.intel.com>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
	 <201206131944.35351.arnd.bergmann@linaro.org>
	 <20120613200033.GB17990@thunk.org>
	 <201206132043.47962.arnd.bergmann@linaro.org>
	 <20120614020757.GB8226@thunk.org>
	 <alpine.LFD.2.02.1206141204591.23555@xanadu.home>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-uyFjNRw+03GyZJSpCsLV"
Cc: Ted Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd.bergmann@linaro.org>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1206141204591.23555@xanadu.home>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-uyFjNRw+03GyZJSpCsLV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-06-14 at 12:14 -0400, Nicolas Pitre wrote:
> Let's not forget that, in almost all cases, filesystem images are not=20
> created live on the final medium.  Factories are picking a batch of=20
> flash devices and a pre-built filesystem image is stamped on them, and=
=20
> there might not even be a guarantee that those flash devices will all=20
> have the same characteristics.  So to say that making this tuning at=20
> mkfs time is probably not the best strategy.

Good point. But we can always set the eraseblock size in the superblock
to -1 which would mean "unknown".

--=20
Best Regards,
Artem Bityutskiy

--=-uyFjNRw+03GyZJSpCsLV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP2hAiAAoJECmIfjd9wqK0mCkP/1McCsw91Q8Bfq4lKtzQT9e5
98V+Mae5hen1FwDqWcCpFo/A3YYIjzbvhb2ufljyw61NYEG+XHQ8+4d169jToC+Z
OnQ5NM0UxukDjy0z2mHgCjHNCnfcpfJDjSrg/LVZ+5oagwEBx1+pu3i+pCoR+asp
+trZGwpGp0WL7moV04P7ruKzwB30K4E0kTiGcadn+YGCtGWSpDmluWY482wg4aGG
GsaLnL0D3t9j7H/yp8qBT6hx+RIhA8GoD5gjd428Opms64SsGhZWQrbQ3dOVAaaQ
Ac1B10u4MSS2RgInrOnMZQlHcWdVx2lcVKPm9wx1GQfkaBLydGs1g20dqv8NpG4g
6HtFiCyVxew+0LRkoWwyed4vbLeRpJ/mQ8Td8nvYktuzHEqmjmxCYmb1gz7GPlri
b256NHmmhoJHZoKvdWHcmazMz73Tde/VRIdn9R2t3C0OVcj8tEGsdwDCch1HD3uP
9AOqbjRe8ys9/ZTwLMVxvRqu4JcBkpv0XfiR5IAY/3m1v7z1y90CiwHJwB+gZS4V
Wf27FCZ/9OzhqRzNXaS4cimYzpkHNpGQJMvlyKTRAaUJI8nd2cSkRifGREEqajvi
G7n+hXHyTJySGkWjVSp0kuTdJZG4vUG++mfVq3OcRUYJ795beU1lj3W/HLbciM31
nh0YIs/GizYmMYFDPxd2
=h0HM
-----END PGP SIGNATURE-----

--=-uyFjNRw+03GyZJSpCsLV--

