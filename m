From: Surbhi Palande <ameyasurbhi@gmail.com>
Subject: Re: ext4: delayed allocation support and mmap
Date: Wed, 17 Aug 2011 14:53:34 +0300
Message-ID: <CABxQaWsDOaNrnmrqUiFRA-HSuxARJMF002o3DfA0VT0xrmgzUw@mail.gmail.com>
References: <CABxQaWsda6PJGLBgdMTGidV_ZcdZrdajJZXgbkRXij3U3_SZAA@mail.gmail.com>
	<20110817114942.GE9959@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60533 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab1HQLxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 07:53:35 -0400
Received: by wwf5 with SMTP id 5so910486wwf.1
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 04:53:34 -0700 (PDT)
In-Reply-To: <20110817114942.GE9959@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 17, 2011 at 2:49 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi,
>
> On Wed 17-08-11 14:02:09, Surbhi Palande wrote:
>> Current ext4_page_mkwrite() implementation always allocates a block
>> through =A0ext4_get_block_write() or ext4_get_block().
> =A0Why do you think so? Look at:
> =A0 =A0 =A0 =A0/* Delalloc case is easy... */
> =A0 =A0 =A0 =A0if (test_opt(inode->i_sb, DELALLOC) &&
> =A0 =A0 =A0 =A0 =A0 =A0!ext4_should_journal_data(inode) &&
> =A0 =A0 =A0 =A0 =A0 =A0!ext4_nonda_switch(inode->i_sb)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0do {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ret =3D __block_page_m=
kwrite(vma, vmf,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_da_get_block_prep);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (ret =3D=3D -ENOSPC &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_should_retry_alloc(i=
node->i_sb, &retries));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out_ret;
> =A0 =A0 =A0 =A0}

Oops! Sorry about that :(

Regards,
Surbhi.




>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
