From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [fstests PATCH] generic: add test for executables on read-only
 DAX mounts
Date: Wed, 30 Aug 2017 07:51:03 -0700
Message-ID: <20170830145103.GA10163@infradead.org>
References: <20170829213721.GA27686@linux.intel.com>
 <20170829223715.26507-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Randy Dodgen <rdodgen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
 fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170829223715.26507-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

> The above patch fixes an issue with ext4 where executables cannot be run on
> read-only filesystems mounted with the DAX option.
> 
> This issue does not appear to be present in ext2 or XFS, as they both pass
> the test.  I've also confirmed outside of the test that they are both
> indeed able to execute binaries on read-only DAX mounts.

It works for me on XFS.  But I don't really understand why, as the fault
handler doesn't look very different.

Maybe the problem is that in ext4_journal_start_sb will fail on
a read-only fs?

Even for xfs/ext2 it would seem odd that things like sb_start_pagefault
just work. 

> +LS=$(which ls --skip-alias --skip-functions) 2>/dev/null
> +if [ $? -ne 0 ]; then
> +	status=$?
> +	echo "Couldn't find 'ls'!?"
> +	exit
> +fi

These checks all fail for me..
