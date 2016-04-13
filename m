From: Toshi Kani <toshi.kani@hpe.com>
Subject: Re: ext4 error
Date: Wed, 13 Apr 2016 08:10:27 -0600
Message-ID: <1460556627.24985.28.camel@hpe.com>
References: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dan.j.williams@intel.com" <dan.j.williams@intel.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"david@fromorbit.com" <david@fromorbit.com>,
	"jack@suse.cz" <jack@suse.cz>, "tytso@mit.edu" <tytso@mit.edu>,
	"adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
	"linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"xfs@oss.sgi.com" <xfs@oss.sgi.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Eric Shang <EricShang@zhaoxin.com>,
	Matthew Wilcox <willy@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0255994B402DE243B1DFC1057A00655201AC6F@ZXSHMBX02.zhaoxin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2016-04-13 at 13:44 +0000, Eric Shang wrote:
> HI All:
> =C2=A0 I meet an ext4 error, following is the error log. After panic,=
 I check the
> emmc by the tool debufs, the inode 69878 i_nlink is not zero. And thi=
s inode
> don't belong to parent dir 6987, it belong to other file(this inode b=
elong to
> two files when check by debugfs ncheck), I guess than this inode has =
beed
> deleted in memory and already used by other file. But the parent dent=
ry
> buff_head not flush to emmc. But when lookup this dentry can't find i=
t' in
> dentry cache, and then lookup_real, read the dentry from emmc, get th=
e file
> inode which already be deleted.
> =C2=A0 Can any give me some help how to check this issue. My kernel v=
ersion is 3.18
> form Android . I thinks something wrong with dentry cache flush and d=
irty
> buff_head flush to emmc. Thanks all!

Are you somehow using DAX and my dax_get_unmapped_area patches in your =
Android
3.18 kernel? I doubt this is the case, but I thought I should check sin=
ce you
reported it to me and Matthew with the same cc list.

If you are simply using a distributed Android kernel, you should report=
 it to
Android email list or bug tracker.

-Toshi
