From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Tue, 18 Feb 2014 15:42:10 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1402181536110.2216@localhost.localdomain>
References: <1392649703-10772-1-git-send-email-lczerner@redhat.com> <20140218010138.GE13997@dastard> <20140218083324.GB28666@dastard> <alpine.LFD.2.00.1402181006250.2216@localhost.localdomain> <20140218094142.GC28666@dastard> <alpine.LFD.2.00.1402181302230.2216@localhost.localdomain>
 <20140218142305.GN26580@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1047372552-1392734533=:2216"
Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20140218142305.GN26580@thunk.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1047372552-1392734533=:2216
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 18 Feb 2014, Theodore Ts'o wrote:

> Date: Tue, 18 Feb 2014 09:23:05 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>, linux-ext4@vger.kernel.org,
>     linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 0/6][RFC] Introduce FALLOC_FL_ZERO_RANGE flag for
>     fallocate
> 
> On Tue, Feb 18, 2014 at 01:04:24PM +0100, Lukáš Czerner wrote:
> >
> > > Ok, so it's a "fallocate" test group, then?
> > 
> > More like "fsx_fsstress" group, which might sound as a terrible name
> > for the group but it explains it quite well. So if you do not have
> > anything against that I'll call the new group "fsx_fsstress"
> 
> How about "block_map" group?  I like Dave's suggestion about naming
> the group after what it is trying to test, as opposed to how it does
> that testing.  This is also consistent with how the other tests groups
> are named in xfstests.
> 
> However, extents are an implementation strategy, and you might just as
> easily use this test to verify whether or not the punch hole
> functionality for indirect block maps worked correctly.

(it does not :) But I am still having trouble deciphering Al Viro
code ;)

> 
> What I think using fsx and fstress together have in common is that
> it's a great way of stress testing whatever the file system uses for
> creating and maintaining the translation map between (inode, logical
> block) to physical block, so that's why perhaps "block_map" might be a
> good test group name.

To be honest "block_map" group name does not mean anything to me.

- "fallocate" is not really the right name as it does much more than
  that
- "extents" is not the right name as there is not really anything
  extents specific.
- "fsx_fsstress" while this gives information about how it is tested
  it's not immediately clear what it is good for.

So I do not know and frankly I do not care very much about the name
of this group so if anyone has a strong opinion about the name feel
free to create such group.

Thanks!
-Lukas

> 
> Regards,
> 
> 						- Ted
> 
--8323328-1047372552-1392734533=:2216--
