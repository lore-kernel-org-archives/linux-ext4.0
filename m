From: Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Sat, 16 Jun 2012 07:28:08 +0000
Message-ID: <201206160728.08687.arnd.bergmann@linaro.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <83D78CE9-16BA-45DE-ADED-88E03DC2E073@dilger.ca> <201206160714.01830.arnd.bergmann@linaro.org>
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
In-Reply-To: <201206160714.01830.arnd.bergmann@linaro.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Saturday 16 June 2012, Arnd Bergmann wrote:
> On Friday 15 June 2012, Andreas Dilger wrote:
> > > Oh, that's cool.  And I don't think that's hard to do.  We could just
> > > keep a flag in the in-core inode indicating whether it is in "large
> > > unit" mode.  If it is in large unit mode, we can make the fs writeback
> > > function make sure that we adhere to the restrictions of the large
> > > unit mode, and if at any point we need to do something that might
> > > violate the constraints, the file system would simply close the
> > > context.
> > 
> > This is very similar to what was implemented in mballoc preallocation.
> > Large files will get their own preallocation context, while small files
> > would share a context (i.e. an 8MB extent) and be packed densely into
> > this extent to avoid seeking.  It wouldn't be unreasonable to just give
> > each mballoc context a different eMMC context.
> 
> My understanding is that once we do that, we have already won much more
> than we can by using contexts, because we get perfect write patterns.
> The only thing that contexts would still buy us is that the device has
> more freedom to cache things separately in each context if we write
> with less than superpage alignment.

Sorry, I replied in the wrong order and had not actually read what Ted
said about actually being able to use the large-unit contexts. If we use
large-unit contexts in write-only mode, that would indeed be a way for
the device to get significantly better than if we just do the alignment.

	Arnd
