From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch 1/2] add init_ext4_proc() stub for when CONFIG_PROC_FS is not set
Date: Wed, 10 Oct 2007 15:00:35 -0400
Message-ID: <20071010190035.GR31713@thunk.org>
References: <20071009055033.145153755@au1.ibm.com> <20071009061101.666614585@au1.ibm.com> <1191947487.12131.33.camel@dyn9047017100.beaverton.ibm.com> <1191949386.3793.16.camel@localhost.localdomain> <20071009174012.GJ31713@thunk.org> <20071010002203.GL31713@thunk.org> <1192030210.12131.61.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mingming Cao <cmm@us.ibm.com>, markn@au1.ibm.com,
	ext4 <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Badari Pulavarty <pbadari@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:43097 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644AbXJJTAv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Oct 2007 15:00:51 -0400
Content-Disposition: inline
In-Reply-To: <1192030210.12131.61.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 10, 2007 at 08:30:10AM -0700, Badari Pulavarty wrote:
> Its a good start. I think there are lots of proc handling routines that
> can be move into #ifdef CONFIG_PROC_FS also.
> 
> All the code around ext4_mb_read_prealloc_table(),
> ext4_mb_write_prealloc_table(), MB_PROC_VALUE_READ(stats),
> MB_PROC_VALUE_WRITE(stats), .. can be ifdefed out.

There's no need to ifdef them out; in include/proc_fs.h there are the
following convenience #define's if CONFIG_PROC_FS is not defined:

#define remove_proc_entry(name, parent) do {} while (0)
static inline struct proc_dir_entry *proc_symlink(const char *name,
		struct proc_dir_entry *parent,const char *dest) {return NULL;}
static inline struct proc_dir_entry *proc_mkdir(const char *name,
	struct proc_dir_entry *parent) {return NULL;}

static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
	mode_t mode, struct proc_dir_entry *base, 
	read_proc_t *read_proc, void * data) { return NULL; }
static inline struct proc_dir_entry *create_proc_info_entry(const char *name,
	mode_t mode, struct proc_dir_entry *base, get_info_t *get_info)
	{ return NULL; }

Adding the #ifdef's just makes the code look ugly, and for no purpose,
since the compiler will take care of removing the code for us.

Regards,

      	  	   	     	     - Ted
