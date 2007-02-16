From: Cordenner jean noel <jean-noel.cordenner@bull.net>
Subject: Re: i_version_3_ext4_user_interface.patch
Date: Fri, 16 Feb 2007 17:00:37 +0100
Message-ID: <45D5D525.6010507@bull.net>
References: <20070215040021.63bde922.akpm@google.com> <20070215173520.GE5285@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@google.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:48278 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbXBPQCR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2007 11:02:17 -0500
In-Reply-To: <20070215173520.GE5285@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Theodore Tso a =E9crit :
> On Thu, Feb 15, 2007 at 04:00:21AM -0800, Andrew Morton wrote:
>> ia64 allmodconfig gives:
>>
>> fs/stat.c: In function `cp_new_stat':
>> fs/stat.c:234: error: structure has no member named `st_i_version'
>>
>> I'll drop the ext4 tree.
>=20
> Looks like the problem is that the patch hacks include/asm-i386/stat.=
h
> and include/asm-x86_64, but no other architecture. =20
>=20
> Jean Noel, I'm going to drop NFSv4 i_version patches from the ext4 tr=
ee
> until all of these issues have been dealt with.
>=20

I agree, there are still some work to do.
Concerning this patch, it's not absolutly needed, but can be usefull.
I'll make it cleaner.
