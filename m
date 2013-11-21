From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd: Lower severity of aborted journal from EMERG to CRIT
Date: Thu, 21 Nov 2013 11:19:45 +0100
Message-ID: <20131121101945.GA23049@quack.suse.cz>
References: <1384527412-23349-1-git-send-email-lkundrak@v3.sk>
 <20131118164533.GF3921@quack.suse.cz>
 <20131119102630.GB5107@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Lubomir Rintel <lkundrak@v3.sk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131119102630.GB5107@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue 19-11-13 02:26:30, Christoph Hellwig wrote:
> On Mon, Nov 18, 2013 at 05:45:33PM +0100, Jan Kara wrote:
> > dead. If it was an important filesystem in your system, the whole system is
> > unusable. In kernel, we don't know whether the filesystem was important or
> > not. So KERN_EMERG isn't adequate in all the cases but KERN_CRIT is
> > neither. What if we made that message print also device name (it would be
> > more useful anyway in that case) and you could then filter out messages for
> > unimportant devices in syslogd?
> 
> What is important or unimportant?  In todays world I don't think a fs
> dying is nessecarily criticial.  A root filesystem might be, but so
> might be any devices that is a single point of failure required for
> operation.
  Agreed. And that is a reason to keep messages KERN_EMERG or change them
to KERN_CRIT? I can see arguments in both ways and so I don't feel a strong
incentive to change what we have now...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
