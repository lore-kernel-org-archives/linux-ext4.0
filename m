From: Tao Ma <tm@tao.ma>
Subject: Re: buggy readdir with inline dirs
Date: Sat, 23 Mar 2013 21:24:33 +0800
Message-ID: <514DAD11.1010709@tao.ma>
References: <20130322182608.GT10038@lenny.home.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
To: Zach Brown <zab@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:57402 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750806Ab3CWNY4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 23 Mar 2013 09:24:56 -0400
In-Reply-To: <20130322182608.GT10038@lenny.home.zabbo.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Zach,
On 03/23/2013 02:26 AM, Zach Brown wrote:
> I don't remember quite how, but I found myself flipping through the
> inline dir code that's in mainline now.  It looked pretty fishy so Eric
> and I played around with it.  It's very buggy in its current form.
Sorry about any inconvenience brought to you.
> 
> ext4_read_inline_dir() doesn't seem to undertand the filldir arguments.
> It suggests that offset 0 is the next offset after both the "." and ".."
> entries.  It needs to have specific offsets for "." and ".." and return them
> accordingly.  It looks like fixing this will trickle down into the
> revalidation loop.
yes, it is my fault, I guess at the very first beginning,  I just can't
figured out how to return a proper 'offset' to the user to indicate
'..'. Now we don't save anything about '.', so offset 0 is OK for it,
but maybe we should return some offset like '2' to the user about it.
Anyway it should be fixed.
> 
> It doesn't understand that it's possible to only return a single "."
> entry in getdents and have a subsequent call have f_pos pointing at the
> fake ".." entry.  With the current code if your getdents buffer only has
> room for "." it just spins returning that entry leaving f_pos at 0.
Sorry.
> 
> Those are all relatively simple bugs that just need to be fixed.
> 
> But the big bug is that it changes the d_off values for entries as it
> converts from byte offsets in the inline dir xattr to hashed offsets in
> indexed dir leaves.  A concurrent readdir could be unlucky enough to get
> a bunch of duplicate entries as it reads past the nice low inline byte
> offsets into the huge hashed offsets.
> 
> I'm not sure how to easily fix that.  It feels like it'd want to
> maintain the dir entries in the xattr blob with the offsets that they'll
> have once converted to full dir blocks.  So instead of being a magical
> readdir path maybe it wants to be in the path of looking up dir blocks
> so existing unindexed and indexed code would operate on the data in the
> xattr blob as though it were a block?
> 
> Dunno, just wanted to share what we found.  Are these all known problems
> in prototype code that isn't intended to be used?
I will check what xfs does in this case as Dave mentioned in another
reply and come back with a fix about it.

Thanks,
Tao
