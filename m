From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Fri, 15 Jun 2012 10:54:22 +0000
Message-ID: <201206151054.22838.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206150925.40625.arnd.bergmann@linaro.org> <94C38A12-AA21-40EF-85AC-B4410F7F03B0@dilger.ca>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Ted Ts'o" <tytso@mit.edu>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <94C38A12-AA21-40EF-85AC-B4410F7F03B0@dilger.ca>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Friday 15 June 2012, Andreas Dilger wrote:
> 
> On 2012-06-15, at 3:25 AM, Arnd Bergmann wrote:
> > 
> > Good point. For flash drives, the specific optimizations we do might
> > be different from what we do on RAID, but they have enough in common
> > that we could use the same mechanism to detect them.
> > 
> > Is ext4 able to cope well with stride sizes between 512KB and 24MB?
> 
> It is typically used on RAID arrays with 1MB or 4MB alignment.

Ok, that sounds like it's the same order of magnitued, which definitely
helps. The most common erase block sizes today are 4 MB and 8 MB,
though they tend to double every one or two years.

> It is considerably more CPU efficient to use power-of-two alignment,
> but it is also possible to use non-power-of-two values if needed, so
> long as they are at least a multiple of the block size.

I see. It's quite common to have a multiple of three nowadays (1.5M B,
3 MB, 6 MB, 12 MB) because of the way that TLC flash is getting used,
but I've also seen TLC based devices that cut a 4 MB erase block in
three parts, rounded to the next superpage size (1376+1376+1344 KB).

In the former case, we might represent that as a stride=2^n and
stripe-width=3*stride if that helps, in the latter case it sounds
like it has to be stride=stripe-width=2^n anyway.
Usually we're interested in the larger of these two sizes anyway.

	Arnd
