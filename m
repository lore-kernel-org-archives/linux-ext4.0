From: Amon Ott <a.ott@m-privacy.de>
Subject: Re: [PATCH] mm: save current->journal_info before calling
 fault/page_mkwrite
Date: Wed, 13 Dec 2017 14:53:55 +0100
Message-ID: <17a0b877-fa5e-fb1d-aa6d-2390d792c6e6@m-privacy.de>
References: <20171213035836.916-1-zyan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
        jlayton@redhat.com
To: "Yan, Zheng" <zyan@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Return-path: <ceph-devel-owner@vger.kernel.org>
In-Reply-To: <20171213035836.916-1-zyan@redhat.com>
Content-Language: de-DE
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Am 13.12.2017 um 04:58 schrieb Yan, Zheng:
> We recently got an Oops report:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: jbd2__journal_start+0x38/0x1a2
> [...]
> Call Trace:
>   ext4_page_mkwrite+0x307/0x52b
>   _ext4_get_block+0xd8/0xd8
>   do_page_mkwrite+0x6e/0xd8
>   handle_mm_fault+0x686/0xf9b
>   mntput_no_expire+0x1f/0x21e
>   __do_page_fault+0x21d/0x465
>   dput+0x4a/0x2f7
>   page_fault+0x22/0x30
>   copy_user_generic_string+0x2c/0x40
>   copy_page_to_iter+0x8c/0x2b8
>   generic_file_read_iter+0x26e/0x845
>   timerqueue_del+0x31/0x90
>   ceph_read_iter+0x697/0xa33 [ceph]
>   hrtimer_cancel+0x23/0x41
>   futex_wait+0x1c8/0x24d
>   get_futex_key+0x32c/0x39a
>   __vfs_read+0xe0/0x130
>   vfs_read.part.1+0x6c/0x123
>   handle_mm_fault+0x831/0xf9b
>   __fget+0x7e/0xbf
>   SyS_read+0x4d/0xb5
> 
> The reason is that page fault can happen when one filesystem copies
> data from/to userspace, the filesystem may set current->journal_info.
> If the userspace memory is mapped to a file on another filesystem,
> the later filesystem may also want to use current->journal_info.
> 
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>

Reported-and-tested-by: Amon Ott <a.ott@m-privacy.de>

Thanks a lot for the patch! I have ported your patch to 4.9.68, tested
and the bug seems fixed now.

Amon Ott
-- 
Dr. Amon Ott
m-privacy GmbH           Tel: +49 30 24342334
Werner-Voß-Damm 62       Fax: +49 30 99296856
12101 Berlin             http://www.m-privacy.de

Amtsgericht Charlottenburg, HRB 84946

Geschäftsführer:
 Dipl.-Kfm. Holger Maczkowsky,
 Roman Maczkowsky

GnuPG-Key-ID: 0x2DD3A649

