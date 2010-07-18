From: shenghui <crosslonelyover@gmail.com>
Subject: Re: [PATCH 2/2] turn BUG_ON for out of bound in mb_cache_entry_find_first/mb_cache_entry_find_next
Date: Sun, 18 Jul 2010 21:59:39 +0800
Message-ID: <AANLkTimM-qRBHxs31AR0xinyvlPpA_Q7qJYGf3G74vgS@mail.gmail.com>
References: <4C43083E.6020201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
To: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, linux-mm@kvack.org,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	kernel-janitors <kernel-janitors@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4C43083E.6020201@gmail.com>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

=E5=9C=A8 2010=E5=B9=B47=E6=9C=8818=E6=97=A5 =E4=B8=8B=E5=8D=889:57=EF=BC=
=8CWang Sheng-Hui <crosslonelyover@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> In mb_cache_entry_find_first/mb_cache_entry_find_next, macro
> mb_assert is used to do assertion on index, but it just prints
> KERN_ERR info if defined.
> Currently, only ext2/ext3/ext4 use the function with index set 0.
> But for potential usage by other subsystems, I think we shoud report BUG
> if we got some index out of bound here.
>
>
> Following patch is against 2.6.35-rc3, and should be
> applied after the first patch.Please check it.
>

Sorry, made a typo. It's against 2.6.35-rc5.

--=20


Thanks and Best Regards,
shenghui

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
