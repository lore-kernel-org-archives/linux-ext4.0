From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 30 Mar 2011 03:33:23 -0700
Message-ID: <20110330103321.GB1564@noexit>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
 <20110204002043.GA15658@noexit>
 <AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
 <20110330003429.GA32669@noexit>
 <AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
 <4D92C508.7010404@tao.ma>
 <AANLkTinV-WSj2c+dtNyaS-r8xf_c0R5UB-_f73XLm0Z8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tao Ma <tm@tao.ma>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTinV-WSj2c+dtNyaS-r8xf_c0R5UB-_f73XLm0Z8@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 30, 2011 at 08:05:38AM +0200, Amir Goldstein wrote:
> Just wanted to clarify there are 2 differences I notice between mmap
> write to a hole
> and mmap write to COWed file with ENOSPC:
> 
> 1. A "good" application can avoid mmap write to a hole.
> 
> 2. when initiating a hole, the mkwrite callback is in used (in ext4) to
> reserve disk space for delayed allocation when a page becomes writable.
> with COW a page may already be writable when the flush encounters COW
> with ENOSPC. that flush can even happen after the application has exited,
> so the data will be dropped on the floor silently (like in ext3).

	ocfs2 doesn't have delayed allocation yet, so we try and fail
the allocation in write_begin() right under mkwrite().

Joel

-- 

The Graham Corollary:

	The longer a socially-moderated news website exists, the
	probability of an old Paul Graham link appearing at the top
	approaches certainty.

			http://www.jlbec.org/
			jlbec@evilplan.org
