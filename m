From: Daniel Phillips <phillips@phunq.net>
Subject: Re: [RFC, PATCH 0/6] ext3: do not modify data on-disk when mounting read-only filesystem
Date: Wed, 12 Mar 2008 19:22:21 -0800
Message-ID: <200803122022.22814.phillips@phunq.net>
References: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com
To: "Duane Griffin" <duaneg@dghda.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752730AbYCMDWj@vger.kernel.org>
In-Reply-To: <1204768754-29655-1-git-send-email-duaneg@dghda.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Duane,

Thanks for doing this.  Some perhaps not so obvious fallout from the bad 
old way of doing things is that ddnap (zumastor) hits an issue in 
replication.  Since ddsnap allows journal replay on the downstream 
server and also needs to have an unaltered snapshot to apply deltas 
against, if we do not take special care, Ext3 will come along and 
modify the downstream snapshot even when told not to.  Our solution: 
take two snapshots per replication cycle (pretty cheap) so that one can 
be clean and the other can be stepped on at will by the journal replay.
Ugh.

With your hack, we can eventually drop the double snapshot, provided no 
other filesystem is similarly badly behaved.

Re your page translation table: we already have a page translation 
table, it is called the page cache.  If you could figure out which file 
(or metadata) each journal block belongs to, you could just load the 
page table pages back in and presto, done.  No need to replay the 
journal at all, you are already back to journal+disk = consistent 
state.

I probably have missed a detail or two since I haven't looked closely at 
how orphan inodes work, revokes, probably other things, but there is 
the basic idea.  SCT, does my reasoning hold water?  (In fact, 
ddsnap "replays" its own journal in exactly this way.  Cache state is 
reconstructed and no actual journal flush is performed.)

Anyway, this is just a theoretical comment, it is in no way a suggestion 
for a rewrite.  The reason for that being, you do not have any 
convenient way to map physical journal blocks back to files and 
metadata.  Maybe if we do implement reverse mapping for Ext3/4 later 
(not just a pipe dream) we could revisit this and lose your extra 
mapping.  As it stands your solution seems well built, after a quick 
readthrough.  Nice looking code.  I think you added about 250 lines 
overall, so tight too.  Thanks again.

Daniel
