From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Date: Tue, 19 Nov 2013 02:26:30 -0800
Message-ID: <20131119102630.GB5107@infradead.org>
References: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
 <20131118164533.GF3921@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Lubomir Rintel <lkundrak@v3.sk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131118164533.GF3921@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Nov 18, 2013 at 05:45:33PM +0100, Jan Kara wrote:
> dead. If it was an important filesystem in your system, the whole system is
> unusable. In kernel, we don't know whether the filesystem was important or
> not. So KERN_EMERG isn't adequate in all the cases but KERN_CRIT is
> neither. What if we made that message print also device name (it would be
> more useful anyway in that case) and you could then filter out messages for
> unimportant devices in syslogd?

What is important or unimportant?  In todays world I don't think a fs
dying is nessecarily criticial.  A root filesystem might be, but so
might be any devices that is a single point of failure required for
operation.
