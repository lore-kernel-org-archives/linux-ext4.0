From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 5/6] ext4: Drop i_state_flags on architectures with 64-bit longs
Date: Thu, 6 Jan 2011 00:23:53 -0700
Message-ID: <B0A77358-77C0-41DB-8281-FC7CEA4BC826@dilger.ca>
References: <1294189270-16733-1-git-send-email-tytso@mit.edu> <1294189270-16733-6-git-send-email-tytso@mit.edu> <5A9C7BCF-AA25-494F-9C64-8A6553B44395@dilger.ca> <20110105202952.GO2959@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:58110 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1AFHXz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Jan 2011 02:23:55 -0500
In-Reply-To: <20110105202952.GO2959@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-01-05, at 13:29, Ted Ts'o wrote:
> On Wed, Jan 05, 2011 at 11:43:08AM -0700, Andreas Dilger wrote:
>> 
>> It looks like you have compensated for the above by changing the
>> code here, but I think it is risky/confusing if clearing the state
>> flags has a side-effect on 64-bit arches, that doesn't exist on
>> 32-bit arches.  It looks like a bug waiting to happen...
> 
> Yeah, I did think of this, but it seemed like extra/needless work that
> I was trying to optimize away.  It's still not safe to do:
> 
> #define EXT4_CLEAR_STATE_FLAGS(ei)      (ei)->i_flags &= 0xffffffffULL;
> 
> ... since we're not atomically updating i_flags.

This code would only be used on a 64-bit arch, so it should be updating the whole word at once (unlike a 32-bit arch).

> So if anyone tries using EXT4_CLEAR_STATE_FLAGS() aside from the two
> allocation contexts, they need to be careful anyway.
> 
> I did think about putting the #ifdef BITS_PER_LONG < 64 inline in the
> code, but that's ugly.  

I'm missing the point of that - isn't the EXT4_CLEAR_STATE_FLAGS() macro
masking already conditional on 64-bit architectures?

The one call in ext4_do_update_inode() that is masking i_flags is redundant,
since the cpu_to_le32() macro is itself either masking the value before
swabbing, and/or it is truncated by the assignment to i_flags.

> Maybe the best thing to do is to clearly document this pitfall, and
> then leave things as-is?   There aren't a lot of great solutions.

It doesn't matter so much to me in the end.  At least documenting this
anomaly is useful, and I don't think that doing the masking is harmful.

Cheers, Andreas





