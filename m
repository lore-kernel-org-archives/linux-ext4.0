From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Thu, 14 Jun 2012 12:14:13 -0400 (EDT)
Message-ID: <alpine.LFD.2.02.1206141204591.23555@xanadu.home>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206131944.35351.arnd.bergmann@linaro.org> <20120613200033.GB17990@thunk.org> <201206132043.47962.arnd.bergmann@linaro.org> <20120614020757.GB8226@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Arnd Bergmann <arnd.bergmann@linaro.org>,
	Alex Lemberg <Alex.Lemberg@sandisk.com>,
	HYOJIN JEONG <syr.jeong@samsung.com>,
	Saugata Das <saugata.das@linaro.org>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	"Luca Porzio (lporzio)" <lporzio@micron.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120614020757.GB8226@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 13 Jun 2012, Ted Ts'o wrote:

> On Wed, Jun 13, 2012 at 08:43:47PM +0000, Arnd Bergmann wrote:
> 
> > For SD cards, almost everyone is lying and we cannot trust the
> > information, and for USB flash, there is no way to ask the device.
> > In both of these cases, we probably want to detect the erase block
> > size at mkfs time using some timing attack that I worked on before.
> > Note that those devices also do not offer support for context IDs.
> 
> Yes, although presumably aligning large files to erase block
> boundaries would still be useful, yes?
> 
> So adding an erase block size to the ext2/3/4 superblock sounds like a
> first great step.  By making it be a superblock field, that way it's
> possible to override the value returned by the hardware if it turns
> out to be a lie, and we can also use programs like flashbench to
> figure out the erase block size and populate the superblock value via
> some userspace process.  (Possibly called out of mke2fs directly if we
> can automate it completely, and make it dead reliable.)

Let's not forget that, in almost all cases, filesystem images are not 
created live on the final medium.  Factories are picking a batch of 
flash devices and a pre-built filesystem image is stamped on them, and 
there might not even be a guarantee that those flash devices will all 
have the same characteristics.  So to say that making this tuning at 
mkfs time is probably not the best strategy.


Nicolas
