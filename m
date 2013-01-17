From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 4/6] block: Optionally snapshot page contents to provide stable pages during write
Date: Wed, 16 Jan 2013 22:26:36 -0500
Message-ID: <yq1hamgjxqr.fsf@sermon.lab.mkp.net>
References: <20130115054235.1563.12967.stgit@blackbox.djwong.org>
	<20130115054305.1563.48197.stgit@blackbox.djwong.org>
	<20130116020000.GA25806@quack.suse.cz>
	<20130117030132.GK6426@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Jan Kara <jack@suse.cz>, axboe@kernel.dk, lucho@ionkov.net,
	ericvh@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk,
	rminnich@sandia.gov, martin.petersen@oracle.com, neilb@suse.de,
	david@fromorbit.com, gnehzuil.liu@gmail.com,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	linux-fsdevel@vger.kernel.org,
	Andy Lutomirski <luto@amacapital.net>,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	linux-ext4@vger.kernel.org, hirofumi@mail.parknet.co.jp
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130117030132.GK6426@blackbox.djwong.org> (Darrick J. Wong's
	message of "Wed, 16 Jan 2013 19:01:32 -0800")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <darrick.wong@oracle.com> writes:

>> Umm, why did you move this hunk?

Darrick> I moved it so that the integrity data are generated against the
Darrick> contents of the bounce buffer because the write paths don't
Darrick> wait for writeback to finish if the snapshotting mode is
Darrick> enabled, which means (I think) that programs can wander in and
Darrick> scribble on the original page in between bio_integrity_prep and
Darrick> blk_queue_bounce.

It's also important that bio_integrity_prep() is run after partition
remapping has taken place. But it looks like that's still the case after
your change.

-- 
Martin K. Petersen	Oracle Linux Engineering
