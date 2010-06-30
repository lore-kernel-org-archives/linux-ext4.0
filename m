From: Nicholas Miell <nmiell@comcast.net>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file
 stats available [ver #2]
Date: Tue, 29 Jun 2010 19:32:41 -0700
Message-ID: <1277865161.2401.12.camel@entropy>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
	 <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:34327 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753389Ab0F3Cco (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jun 2010 22:32:44 -0400
In-Reply-To: <20100630011712.18960.3723.stgit@warthog.procyon.org.uk>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 2010-06-30 at 02:17 +0100, David Howells wrote:
> Add a pair of system calls to make extended file stats available, including
> file creation time, inode version and data version where available through the
> underlying filesystem:
> 
> 	struct xstat_dev {
> 		unsigned int	major;
> 		unsigned int	minor;
> 	};
> 
> 	struct xstat_time {
> 		unsigned long long	tv_sec;
> 		unsigned long long	tv_nsec;
> 	};
> 
> 	struct xstat {
> 		unsigned int		struct_version;
> 	#define XSTAT_STRUCT_VERSION	0
> 		unsigned int		st_mode;
> 		unsigned int		st_nlink;
> 		unsigned int		st_uid;
> 		unsigned int		st_gid;
> 		unsigned int		st_blksize;
> 		struct xstat_dev	st_rdev;
> 		struct xstat_dev	st_dev;
> 		unsigned long long	st_ino;
> 		unsigned long long	st_size;
> 		struct xstat_time	st_atime;
> 		struct xstat_time	st_mtime;
> 		struct xstat_time	st_ctime;
> 		struct xstat_time	st_btime;
> 		unsigned long long	st_blocks;
> 		unsigned long long	st_gen;
> 		unsigned long long	st_data_version;
> 		unsigned long long	query_flags;
> 	#define XSTAT_QUERY_SIZE		0x00000001ULL
> 	#define XSTAT_QUERY_NLINK		0x00000002ULL
> 	#define XSTAT_QUERY_AMC_TIMES		0x00000004ULL
> 	#define XSTAT_QUERY_CREATION_TIME	0x00000008ULL
> 	#define XSTAT_QUERY_BLOCKS		0x00000010ULL
> 	#define XSTAT_QUERY_INODE_GENERATION	0x00000020ULL
> 	#define XSTAT_QUERY_DATA_VERSION	0x00000040ULL
> 		unsigned long long	extra_results[0];
> 	};
> 

unsigned long long inside a struct has 4 byte alignment on x86, while
AMD64 has 8 byte alignment. This struct layout isn't affected by the
difference, but that's something to keep in mind.
-- 
Nicholas Miell <nmiell@comcast.net>

