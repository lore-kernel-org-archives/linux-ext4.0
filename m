From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing
 device needs stable page writes
Date: Thu, 1 Nov 2012 10:24:48 -0700
Message-ID: <5092B060.9070604@panasas.com>
References: <20121026101909.GB19617@blackbox.djwong.org> <20121027013524.GA19591@blackbox.djwong.org> <yq1ehkg8us1.fsf@sermon.lab.mkp.net> <20121030154844.1898f068@notabene.brown> <yq1a9v4884i.fsf@sermon.lab.mkp.net> <20121030201424.GD19559@blackbox.djwong.org> <20121031091441.5fc6b412@notabene.brown> <20121031085604.GC19591@blackbox.djwong.org> <20121031115614.GC18424@quack.suse.cz> <20121031193652.GF19591@blackbox.djwong.org> <20121101085942.GA6584@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
	NeilBrown <neilb@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20121101085942.GA6584@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 11/01/2012 01:59 AM, Jan Kara wrote:
<>
> (all block device inodes share one superblock).
> 

Really? that is not so good is it, for other obvious reasons. 
Why is it not one superblock per BDI? That would be more obvious
to me.

> Thoughts?

It's a really bad design. I think it is worth fixing. For the above
problem, as well as a much better fit with our current thread-per-bdi,
and the rest of the Kernel model. No?

> 
> 									Honza
> 

Thanks
Boaz
