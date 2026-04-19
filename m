Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0422613777E
	for <linux-ext4@vger.kernel.org>; Sun, 19 Apr 2026 21:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776635945; cv=none; b=L7VfW4Zgp0jy2NyW/+D5ysKw7tTHWJHVegldVVK4e8F/LrurSKXJFX3+p/m0J7UDFMjFDHZsoDsbHpOvZd3TOFNIvB4h08DxhxNuOe346QDKZ3hRVvnjU2/cVV1PxqugptzlP7G96tofpzrd3no/vznEPQiRoXX10rXSpYmQ+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776635945; c=relaxed/simple;
	bh=20js9pG0zQ2naC+r7vTB3OsG9cL6V6oq9ntEcBDzdws=;
	h=Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:From; b=p1sm1jmhyoZGH1k9x4Itkv6PLt0u6hEnIO/LnyK5fT52VeOqbbrdYvfu1+H46Ao08xaVwmSeeeBCRQebof6xM9CrNa4c6rBGboE0cD54OS+OnNmsTsPE3OtkZ5/oM07TH0mbpJX7z4WwJY/KWKKViFAasUqVfZipkOezlwcLhak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=CTzFGOWs; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="CTzFGOWs"
Received: from macsyma.thunk.org (pool-173-48-114-3.bstnma.fios.verizon.net [173.48.114.3])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 63JLwpNN005547
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 19 Apr 2026 17:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1776635933; bh=0wsJoqNR69RdXjL+9d9X3pDLi2w6txlGu2cX0VKfCUw=;
	h=Date:Subject:Message-ID:MIME-Version:Content-Type:From;
	b=CTzFGOWscTZgNSWskEiWaia6A4e7jiVd+w10bpoWkKJmEGLttQ/W5sPIh8o381Drj
	 ZFR8SV7xGWyZyQyonv44SJnh0undra0FiRDYzSXjcOcakYqxsIVK9oquYlziat16tA
	 ZCux0olY1rAK2rgcRbXq9Tg2bS4MQdksQHa7sTuIVfb3W5fbQMQYXchGS0Kj3VKIaC
	 9b3wJ7tOgG4SgHVV7Ox1NeOGRPAGFWdEdnQMwpw0H8dSI1CrB57P5LD19p8AyGdhiM
	 8fEyUYCJak5ZBFCthqP7bMj0YEN5fsqQfX0pk0KZLYfWiEPEk+SIYpya0dQTIIVBvU
	 ZPEbM+mMSmvwQ==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 980DE63CE561; Sun, 19 Apr 2026 17:57:51 -0400 (EDT)
Date: Sun, 19 Apr 2026 17:57:51 -0400
To: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca
Subject: Re: [PATCH 0/3] Data in direntry (dirdata) feature
Message-ID: <20260419215751.GD58909@macsyma-wired.lan>
References: <20260417213723.74204-1-artem.blagodarenko@gmail.com>
 <20260418214359.GA58909@macsyma-wired.lan>
 <CA+rD4x8uk7h7dv_Mg1tMXXiVZZD1YAj5WAw+6GNuMKQAAMueuQ@mail.gmail.com>
 <20260419004716.GB58909@macsyma-wired.lan>
 <CA+rD4x_5pRycXgqQ=j3FmZC+Q1KpRPYLv84uY0c0VRtq63uT3A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-ext4@vger.kernel.org
List-Id: <linux-ext4.vger.kernel.org>
List-Subscribe: <mailto:linux-ext4+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-ext4+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+rD4x_5pRycXgqQ=j3FmZC+Q1KpRPYLv84uY0c0VRtq63uT3A@mail.gmail.com>
`From: Theodore Tso <tytso@mit.edu>
From: tytso@mit.edu (Theodore Tso)

On Sun, Apr 19, 2026 at 08:37:51PM +0100, Artem Blagodarenko wrote:
> On Sun, 19 Apr 2026 at 01:48, Theodore Tso <tytso@mit.edu> wrote:
> > I'm not seeing that in the patches that was sent out to the list last
> > week.  Where is that?
> 
> I have just sent it to the xfstests mail list and placed you to cc
> 
> > I traced all of the places where ext4_insert_dentry_data() and
> > ext4_dirdata_set() and I don't see *anything* where dirdata was
> > stored, including the fscrypt + casefold hash.   What am I missing?
> 
> dirdata feature should be enabled, and  fscrypt + casefold used
> The new xfstest ext4/065 should help here

Can you show *where* in the patched sources the dirdata gets set in
the fscrypt + casefold case?

Also, there is no real value to users for storing the hash with
fscrypt and casefold using dirdata --- unless they are using dirdata
for some other uses --- but the 64-bit inode number will require
significantly more code changes that's not here.  So there is no
user-visible additional functionality of dirdata.  That's why the
tests that you sent aren't particularly useful.  It doesn't actually
test that the fscrypt hash was stored in dirdata when the dirdata
feature enabled.  It just shows that nothing broke, which is *not* the
same thing.

Another way to demonstrate that that that your tests didn't really
test anything is due to another flaw in your patches.  In addition to
the dirdata feature, there is *also* a dirdata mount option.  If the
dirdata mount option is not specified, then the dirdata flags will get
omitted:

static inline unsigned char get_dtype(struct super_block *sb, int filetype)
{
	unsigned char fl_index = filetype & EXT4_FT_MASK;

	if (!ext4_has_feature_filetype(sb) || fl_index >= EXT4_FT_MAX)
		return DT_UNKNOWN;

	if (!test_opt(sb, DIRDATA))
		return ext4_filetype_table[fl_index];

	return (ext4_filetype_table[fl_index]) |
		(filetype & ~EXT4_FT_MASK);
}

But your proposed new test doesn't *actually* set the dirdata mount
option.  So in addition to my not able to find any place where dirdata
gets *set*, this flaw in your patch (I think it was left over from
when you were using a mount option instead of a file system feature),
meant that nothing could possibly *get* the dirdata flag.  Despite
that, your tests are apparently passing, and you apparently didn't
notice that dirdata support is a no-op.


Finally, please take a look at the KASAN bugs which syzbot found,
which includes some use after frees and out-of-bounds bugs.  (This may
mean that there are some real security bugs in your Luster production
patches that could be found by mechanisms such as Anthropic's Mythos,
so you may want to consider whether the bugs found by Syzkaller might
be applicable in your current product patches.)

https://ci.syzbot.org/series/590e846e-42c0-4497-b6ae-b95ed4468941

Also, if you can rebase your patches onto Linux 7.0 when you send the
next around, then Sashiko will be able to review your patches.

I also suggest that you consider breaking up the patches into smaller
chunks.  This makes them easier to review, and perhaps you would have
noticed that the patch was still defining a worse-than-useless dirdata
mount option.

Finally, perhaps you should consider adding a Kunit test for dirdata?
That would allow you to test the LUFID functionality without needing
to plumb through extra userspace interfaces such as an
EXT4_IOC_SET_LUFID ioctl.

Cheers,

						- Ted
