From: Nathan Scott <nscott@aconex.com>
Subject: Re: ZFS, XFS, and EXT4 compared
Date: Thu, 30 Aug 2007 17:07:46 +1000
Message-ID: <1188457666.24970.94.camel@edge.yarra.acx>
References: <1188454611.23311.13.camel@toonses.gghcwest.com>
Reply-To: nscott@aconex.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: zfs-discuss@opensolaris.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org
To: "Jeffrey W. Baker" <jwbaker@acm.org>
Return-path: <xfs-bounce@oss.sgi.com>
In-Reply-To: <1188454611.23311.13.camel@toonses.gghcwest.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Wed, 2007-08-29 at 23:16 -0700, Jeffrey W. Baker wrote:
> ...  xfs has great
> sequential transfer but really bad metadata ops, like 3 minutes to tar
> up the kernel. 

Perhaps this is due to the write barrier support - would be interesting
to try a run with the "-o nobarrier" mount option to XFS.  With external
logs, write barriers are automatically disabled, which may explain:
 "Oddly XFS has better sequential reads when using an external journal,
 which makes little sense."

To improve metadata performance, you have many options with XFS (which
ones are useful depends on the type of metadata workload) - you can try
a v2 format log, and mount with "-o logbsize=256k", try increasing the
directory block size (e.g. mkfs.xfs -nsize=16k, etc), and also the log
size (mkfs.xfs -lsize=XXXXXXb).

Have fun!

cheers.

--
Nathan
