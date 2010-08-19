From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: buggy EOFBLOCKS_FL handling
Date: Thu, 19 Aug 2010 12:33:36 -0600
Message-ID: <452C1BF7-6BB9-4BB5-AA03-7D9959C416E0@dilger.ca>
References: <E1OlvNi-00063m-09@tytso-glaptop> <FB932B24-52F7-4C97-9BF6-58A78DFA5FBF@dilger.ca> <20100819144432.GA23345@thunk.org> <4C6D63D5.8030600@redhat.com> <20100819171128.GA3468@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:15512 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab0HSSdh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 19 Aug 2010 14:33:37 -0400
In-Reply-To: <20100819171128.GA3468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-08-19, at 11:11, Ted Ts'o wrote:
> On Thu, Aug 19, 2010 at 12:03:17PM -0500, Eric Sandeen wrote:
>> 
>> Maybe e2fsck could tally these and after I dunno, 10 or 20 or so, ask
>> whether it should keep flagging them or just go into "yes" mode for
>> the rest of the inodes with that problem?
> 
> Maybe.  I'd need to do some testing to see what percentage of the
> "takes hours longer" is caused by needing to fix truly vast numbers of
> inodes, versus the fact that writing the e2fsck log file was taking a
> huge amount of time.  I'm not sure, asking the user, "I've tried
> fixing 100 of these inodes, and it looks like there are runs more,
> want to skip checking for the rest" is all that great (i.e., a "go
> into automatic 'no' mode for this question").
> 
> The other possibility is that I'd make it configurable by e2fsck.conf,
> but change the default to be "ignore this fs error", and then 2-3
> years later, change the default to "check for this fs error", without
> actually requiring most users to have a knob in their e2fsck.conf
> file.

To me this falls into the class of "silently fix our mistake" kind of problem, similar to what we did in the Lustre e2fsprogs with the extent "_hi" field not being initialized in early versions of the extent patch.

If the slowdown is due to actually updating thousands of such inodes (vs. just printing the error on the screen) you could cap the number of inodes fixed for this problem at some limit, and then every time a full e2fsck is run it would fix a bunch more.

Presumably an updated kernel and regular filesystem usage would also tend to clean up this flag if old files are deleted and new ones created, but it is good to have e2fsck do it also, for files that are not modified for a long time.

Cheers, Andreas





