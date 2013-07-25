From: Phillip Lougher <phillip.lougher@gmail.com>
Subject: Re: [RFC/PATCH 0/2] ext4: Transparent Decompression Support
Date: Thu, 25 Jul 2013 16:29:41 +0100
Message-ID: <CAB3wodfp88G62YGU1hB_P4SSj3CiV3MjY1-Jn5FDr_GJ2KtYHQ@mail.gmail.com>
References: <1374699833.7083.2.camel@localhost>
	<20130724233628.GD3641@logfs.org>
	<51F14136.30409@mozilla.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>,
	linux-kernel@vger.kernel.org, tytso@mit.edu, tglek@mozilla.com,
	vdjeric@mozilla.com, glandium@mozilla.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Dhaval Giani <dgiani@mozilla.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <51F14136.30409@mozilla.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 25 July 2013 16:16, Dhaval Giani <dgiani@mozilla.com> wrote:
> On 07/24/2013 07:36 PM, J=F6rn Engel wrote:

>
>> Assuming you use the chattr approach, that pretty much comes down to
>> adding compression support to ext4.  There have been old patches for
>> ext2 around that never got merged.  Reading up on the problems
>> encountered by those patches might be instructive.
>
>
> Do you have subjects for these? When I googled for ext4 compression, =
I found
> http://code.google.com/p/e4z/ which doesn't seem to exist, and checki=
ng in
> my LKML archives gives too many false positives.
>

The ext2 compression project was called e2compr, http://e2compr.sourcef=
orge.net/

Also just google for "e2compr".

Phillip

> Thanks!
> Dhaval
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdev=
el" in
>
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
