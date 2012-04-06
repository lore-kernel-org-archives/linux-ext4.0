From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Commit c1a1e7fc24d6 causes segfault in ext2fs_new_inode
Date: Fri, 06 Apr 2012 12:49:22 -0700
Message-ID: <4F7F48C2.9000703@redhat.com>
References: <20120330125726.GA26221@amd.home.annexia.org> <20120330131936.GB26221@amd.home.annexia.org> <4F760BC2.4070401@redhat.com> <20120406191401.GA8816@sli.dy.fi> <4F7F41C1.9010208@redhat.com> <4F7F448D.5040808@redhat.com> <20120406194742.GB8816@sli.dy.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Richard W.M. Jones" <rjones@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757671Ab2DFTtb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 6 Apr 2012 15:49:31 -0400
In-Reply-To: <20120406194742.GB8816@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 4/6/12 12:47 PM, Sami Liedes wrote:
> On Fri, Apr 06, 2012 at 12:31:25PM -0700, Eric Sandeen wrote:
>> However, there seems to be some unstated (?) naming convention about foo_bmap
>> (for 64-bit bitmaps) vs. foo_bitmap (for 32-bit bitmaps), and "bitmap2"
>> functions which seem to take 64-bit args, etc.  I'm not sure if this new
>> function needs to follow similar conventions...
> 
> I guess... I thought I had figured those out when I sent the patch,
> but I'm not so sure anymore :-)
> 
>> My patch is probably overkill, so I won't bother to send it unless Ted
>> thinks something like that is necessary.  Documenting the api preservation
>> framework for 64-bit bitmaps would be really helpful, I think.
> 
> Yeah, I'm sorry it took me a while to look at this and for causing you
> extra work.

No worries, I could have waited, too ;)  Thanks!

- -Eric
 
> 	Sami

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.17 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJPf0jAAAoJECCuFpLhPd7g2V8P/Rdmakt3hb1mh0C7eu01Cpxw
X16f5Axzhsn0c0bfZsKeEZLB6bM+5TYdlARXATxfnVEZ/upbyCsF6bqZ0I5JxHj5
wTRuB7pwl8E+7vBANOu7aI7YT1Vb0eM2i3zIRONeqkYYYbRGllKeUPCdibnL2T5+
ybiAp2tXLR665LYtt0xcHVQ63L0NfYiditmpoMpxWKNfbu4OGhnpTw6bouzzdg1f
KeXQkMdd26oIl8myrp/zkuHCUtja9aSmv4KrcMcxOuFyCqCuyrQpwDx78fmKpnn8
njy/dqI2QY9c/FmScYcXyAQ6/SJ2gkzjm60dkLT8DvPYLky0ytdQQ3JeFh/kBZX9
iGnRSj+fPjujVtzG73x5d5Q8ayzr6jGR94Vm/krvBJ4Yz5GBJkcuR16/8Lmze8au
oKbaKx4PrvuRqD4PEKzmfkUpVFK0GDbXkKgG0wycU/qaFa8hrTrjIo3web3wNbUc
lZExrKB4Pazu65xrQHQih1uENzlJlC1vkhi99oqnrRDmc4/bvuprp//X9SxboGV+
nglwMEEFL7djPM4GSUMWEFz3qTDLZIXqjPV9XfJJvk6G62BbOHn2Q5YfIsyjNQOx
Wr26EkiGui5OXRAAJ9EYdqtSjip1CPyM05CibOQJeZLDZREmchgJKE0PMcLdWziV
y0l4cQNDitg/8ruuBMKk
=jMuN
-----END PGP SIGNATURE-----
