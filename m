From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
Date: Thu, 08 Aug 2013 15:58:39 -0700
Message-ID: <5204229F.8000507@intel.com>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz> <520286A4.1020101@intel.com> <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com> <20130808101807.GB4325@quack.suse.cz> <CALCETrX1GXr58ujqAVT5_DtOx+8GEiyb9svK-SGH9d+7SXiNqQ@mail.gmail.com> <20130808185340.GA13926@quack.suse.cz> <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

I was coincidentally tracking down what I thought was a scalability
problem (turned out to be full disks :).  I noticed, though, that ext4
is about 20% slower than ext2/3 at doing write page faults (x-axis is
number of tasks):

http://www.sr71.net/~dave/intel/page-fault-exts/cmp.html?1=ext3&2=ext4&hide=linear,threads,threads_idle,processes_idle&rollPeriod=5

The test case is:

	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault3.c

A 'perf diff' shows some of the same suspects that you've been talking
about, Andy:

	http://www.sr71.net/~dave/intel/page-fault-exts/diffprofile.txt

>      2.39%   +2.34%  [kernel.kallsyms]      [k] __set_page_dirty_buffers               
>              +2.50%  [kernel.kallsyms]      [k] __block_write_begin                    
>              +2.16%  [kernel.kallsyms]      [k] __block_commit_write                   

The same test on ext4 but doing MAP_PRIVATE instead of MAP_SHARED goes
at the same speed as ext2/3:

	https://github.com/antonblanchard/will-it-scale/blob/master/tests/page_fault2.c

This is looking to me more like an ext4-specific problem that needs to
get solved rather than through some interfaces (like MADV_WILLWRITE).

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
