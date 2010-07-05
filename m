From: Brad Boyer <flar@allandria.com>
Subject: Re: [PATCH 0/3] Extended file stat functions [ver #2]
Date: Mon, 5 Jul 2010 16:52:11 -0700
Message-ID: <20100705235211.GB12517@cynthia.pants.nu>
References: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: viro@ZenIV.linux.org.uk, smfrench@gmail.com, jlayton@redhat.com,
	mcao@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
	linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org,
	sjayaraman@suse.de, linux-ext4@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100630011656.18960.4255.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 30, 2010 at 02:16:56AM +0100, David Howells wrote:
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
> 	#define XSTAT_QUERY__ORDINARY_SET	0x00000017ULL
> 	#define XSTAT_QUERY__GET_ANYWAY		0x0000007fULL
> 	#define XSTAT_QUERY__DEFINED_SET	0x0000007fULL
> 		unsigned long long	extra_results[0];
> 	};

Would it be worthwhile to have a field for which security features are
enabled for a file? Maybe with bits for if the file has ACLs (and which
type if the richacl code goes in) or for the selinux labels or other
similar types of data? The current version of ls I have does a huge
pile of getxattr calls along with all the lstat64 calls.

	Brad Boyer
	flar@allandria.com
