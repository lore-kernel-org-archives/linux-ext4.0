From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] ext2: No longer export ext2_fs.h to user space
Date: Sat, 24 Mar 2012 15:16:37 -0700
Message-ID: <4F6E47C5.6040306@zytor.com>
References: <20120322183135.GC4028@thunk.org> <1332494856-31943-1-git-send-email-thierry.reding@avionic-design.de> <20120323131331.GA29631@thunk.org> <20120323175534.GI6589@ZenIV.linux.org.uk> <20120324215152.GA32554@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: "Ted Ts'o" <tytso@mit.edu>, Al Viro <viro@ZenIV.linux.org.uk>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Andreas Dilger <aedilger@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120324215152.GA32554@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 03/24/2012 02:51 PM, Ted Ts'o wrote:
> Peter,
> 
> Note that we are planning on unexporting ext2_fs.h, and then utterly
> removing it from the tree (with what fs/ext2 needs being moved to
> fs/ext2/ext2.h).
> 
> Someone who was compiling "the latest version" of syslinux has
> submitted a kernel bugzilla entry that this was breaking due to
> ext2_fs.h using umode_t which was no longer being exported by the
> kernel header files.  Given that ext2_fs.h is about to go ***poof***
> (Al already has the changes in his vfs git tree), I thought I should
> give you a heads up....
> 

Thanks.  Syslinux already includes a private copy of ext2_fs.h, but I
need to scrub the umode_t inclusion.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
