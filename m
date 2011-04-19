From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: Files full of zeros with coreutils-8.11 and xfs (FIEMAP related?)
Date: Wed, 20 Apr 2011 07:08:25 +1000
Message-ID: <20110419210825.GJ23985@dastard>
References: <20110416005040.GP21395@dastard>
	<E7438588-5C5A-42B9-9B6C-FADF7CAC6D3A@dilger.ca>
	<4EEEA16E-1FDB-4430-A372-8F8701196E4C@mit.edu>
	<20110418004040.GS21395@dastard>
	<6C89E159-A5F6-4A06-A3D2-273BE4CFB9B5@dilger.ca>
	<BANLkTin=WEpSf6ddiOMNMOpCPP-wiEttSw@mail.gmail.com>
	<20110419034455.GB23985@dastard>
	<BANLkTinjh968ECqAobQ677hnV5yzke1ncw@mail.gmail.com>
	<20110419074538.GG23985@dastard> <20110419140909.GD3030@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>, Eric Sandeen <sandeen-+82itfer+wXR7s880joybQ@public.gmane.org>,
	Yongqiang Yang <xiaoqiangnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, xfs-oss <xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org>,
	"coreutils-mXXj517/zsQ@public.gmane.org" <coreutils-mXXj517/zsQ@public.gmane.org>,
	"linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Markus Trippelsdorf <markus-xp2qqqlHh3xzoYq+O6RWwA@public.gmane.org>
To: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110419140909.GD3030-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
List-Unsubscribe: <http://lists.gnu.org/mailman/options/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=unsubscribe>
List-Archive: </archive/html/coreutils>
List-Post: <mailto:coreutils-mXXj517/zsQ@public.gmane.org>
List-Help: <mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.gnu.org/mailman/listinfo/coreutils>,
	<mailto:coreutils-request-mXXj517/zsQ@public.gmane.org?subject=subscribe>
Errors-To: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
Sender: coreutils-bounces+gcgcg-coreutils=m.gmane.org-mXXj517/zsQ@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Apr 19, 2011 at 10:09:09AM -0400, Ted Ts'o wrote:
> On Tue, Apr 19, 2011 at 05:45:38PM +1000, Dave Chinner wrote:
> > You are *not listening*. There is no #2. FIEMAP returns the extent
> > state _on disk_ at the time of the call.
> 
> Dave, you're being rather strident about your insistence about what
> FIEMAP's semantics are. 

The bit about the page cache state being relevant? That's what I was
refering to here.

> Part of the problem here is that it's *not*
> clear or settled.
> 
> If it really is the state _on_ _disk_, does XFS really have a DELALLOC
> bit _on_ _disk_?

Sigh. No.

This whole thing blew up because of unwritten extent behaviour when
there is dirty page cache covering and unwritten extent. Delalloc
was not the issue - what I said is absolutely true for unwritten
extents.  Somewhere in the middle someone started talking about
delalloc extents and conflating their behaviour with unwritten
extents, but I continued to talk about unwritten extents and
cached pages.

Even so, for delalloc extents the dirty page state in the page cache
is irrelevant. I've said earlier that XFS delalloc extents can span
regions that have no page cache state - they don't get reported as
holes by FIEMAP because they are tracked as delalloc. IOWs, like
unwritten extents, you can't rely on delalloc extents to tell you
where the data is in the file.

So, it logically follws that you need to use the SYNC flag for both
unwritten extents and delalloc extents to find out where there data
realy lies by converting them to real, written extents. i.e. the
only extents you can trust contain data from FIEMAP are the real
extents on disk....

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org
