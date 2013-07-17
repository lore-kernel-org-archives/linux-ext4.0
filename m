From: Dave Jones <davej@redhat.com>
Subject: Re: ext4_da_release_space:1333: ext4_da_release_space: ino 12,
 to_free 1 with only 0 reserved data  blocks
Date: Wed, 17 Jul 2013 17:42:35 -0400
Message-ID: <20130717214235.GB12401@redhat.com>
References: <20130716202533.GA16061@redhat.com>
 <20130717125322.GA29294@quack.suse.cz>
 <20130717145218.GA27731@redhat.com>
 <20130717213850.GA5025@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130717213850.GA5025@quack.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jul 17, 2013 at 11:38:50PM +0200, Jan Kara wrote:

 > > It was running this.. https://github.com/kernelslacker/io-tests/blob/master/setup.sh
 > > in a loop. After about 6 hours, that fell out.  It made it all the way through
 > > every test a few times, which is odd, as the test should be fairly deterministic.
 > > Ah, I wasn't capturing the fsx seed. I'll do that on the next run.
 >   So inode 12 was likely the file used by fsx. OK. Looking at the script
 > link, fsx is run as:
 >   /usr/local/bin/fsx -N 250000 -S0 foo &
 > so the seed is always 0. So it is a deterministic test and there must be
 > some race with writeback or something that is rarely triggered. Drat.

S0 is special. it means 'use timeofday as seed'

	Dave
