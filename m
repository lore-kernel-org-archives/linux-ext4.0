From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Thu, 14 Jun 2012 15:08:57 -0400 (EDT)
Message-ID: <alpine.LFD.2.02.1206141505300.23555@xanadu.home>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com> <201206131944.35351.arnd.bergmann@linaro.org> <20120613200033.GB17990@thunk.org> <201206132043.47962.arnd.bergmann@linaro.org> <20120614020757.GB8226@thunk.org>
 <alpine.LFD.2.02.1206141204591.23555@xanadu.home> <20120614170533.GA15093@thunk.org>
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
In-Reply-To: <20120614170533.GA15093@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 14 Jun 2012, Ted Ts'o wrote:

> On Thu, Jun 14, 2012 at 12:14:13PM -0400, Nicolas Pitre wrote:
> > Let's not forget that, in almost all cases, filesystem images are not 
> > created live on the final medium.  Factories are picking a batch of 
> > flash devices and a pre-built filesystem image is stamped on them, and 
> > there might not even be a guarantee that those flash devices will all 
> > have the same characteristics.  So to say that making this tuning at 
> > mkfs time is probably not the best strategy.
> 
> Sure, that just means there needs to be a way of overriding the values
> used by mke2fs.  (Because as you create the fs image, the storage
> device parameters may make a difference to how blocks get allocated.)
> 
> The reason why I talk about making it work automatically at mke2fs
> time is that the vast majority of created file systems (where a
> specially created fs by a handset vendor counts as "one", even if it
> then gets stamped on millions of devices), the end user is someone
> naive/oblivious, so the right thing *has* to happen by default in the
> common case of running mke2fs on the storage device where the file
> system gets used.

Absolutely.  However it is fair to say that less than 0.01% of total end 
users will even think of running mke2fs on their device.  So another 
strategy that can be executed at run time when the fs is live would be 
required too.


Nicolas
