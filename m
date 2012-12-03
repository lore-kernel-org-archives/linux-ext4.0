From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH V7 03/23] ext4: Add the basic function for inline data
 support.
Date: Mon, 03 Dec 2012 13:23:24 +0800
Message-ID: <50BC374C.7050705@tao.ma>
References: <1351047002-4723-1-git-send-email-tm@tao.ma> <1351047338-4963-1-git-send-email-tm@tao.ma> <1351047338-4963-3-git-send-email-tm@tao.ma> <20121203014823.GA5507@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:38539 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750766Ab2LCFX2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Dec 2012 00:23:28 -0500
In-Reply-To: <20121203014823.GA5507@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/03/2012 09:48 AM, Theodore Ts'o wrote:
> On Wed, Oct 24, 2012 at 10:55:18AM +0800, Tao Ma wrote:
>> +	EXT4_STATE_MAY_INLINE_DATA,	/* may have in-inode data */
> 
> Can you write a paragraph or two about exactly what the semantics are
> of this state flag --- what it means, when it should be set, and when
> it should be cleared, etc.?
> 
> I'm not entirely sure I understand why you test
> EXT4_STATE_MAY_INLINE_DATA versus simply calling
> ext4_has_inline_data() in various places.
OK, so in general, EXT4_STATE_MAY_INLINE_DATA is a flag that show that
the file has a potential to be inlined, but there is no guarantee it is
inlined.

So when the inode is created and the volume has inline-data support,
this flag is set. And when the write_begin comes, we have no idea
whether it is OK or not to create an inline file, so if this flag is
set, we just try to call the inline-data stuff to see whether it works.
If it succeeds, that is cool. But if not, this flag is cleared and we
will not trap to inline-data stuff for the future write_begin. The
reason why ext4_has_inline_data() doesn't work here is that a new file
has no inline data but has the potential to be inlined.

Thanks
Tao
