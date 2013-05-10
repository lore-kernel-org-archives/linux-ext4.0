From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4 panic at jbd2_journal_put_journal_head() in 3.9+
Date: Fri, 10 May 2013 15:27:47 -0400
Message-ID: <20130510192747.GA11707@thunk.org>
References: <6719519.5821368147110937.JavaMail.weblogic@epml17>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: EUNBONG SONG <eunb.song@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6719519.5821368147110937.JavaMail.weblogic@epml17>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hmm, since you seem to be able to reproduce the problem reliably, any
chance you can try bisecting the problem?  I've looked at the commits
that touch fs/jbd2 and nothing is jumping out at me.

Also, how many CPU's do you have your system, and what kind of storage
device were you using when you were running iozone (5400rpm HDD,
7200RPM HDD, RAID array, SSD, etc.)?

Thanks,

						- Ted
