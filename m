From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH 2/2] Jbd: fix a bug of leaking jh->b_jcount
Date: Wed, 25 May 2011 19:47:14 +0800
Message-ID: <BANLkTim992S6+iGEN12NfcuOz-UOSe2prQ@mail.gmail.com>
References: <1306318841-8363-1-git-send-email-dingdinghua@nrchpc.ac.cn>
	<BANLkTik=B08XzLViSD10Z_bac6R5DqswmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Ding Dinghua <dingdinghua@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33013 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753961Ab1EYLrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 May 2011 07:47:15 -0400
Received: by vws1 with SMTP id 1so5695878vws.19
        for <linux-ext4@vger.kernel.org>; Wed, 25 May 2011 04:47:14 -0700 (PDT)
In-Reply-To: <BANLkTik=B08XzLViSD10Z_bac6R5DqswmA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, May 25, 2011 at 7:37 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Hi,
>
> m/N means that there are N patches and this patch is the mst one. e.g=
=2E
> 2/30 means the patch series contain 30 patches and this is the 2nd
> one.
>
> When a patch is resent, you'd better send it with [PACH vm], where m
> is the version number.
Sorry,  two patches are different, please ignore comments above.
>
> Again, you missed Signed-off-by: line.
>
> On Wed, May 25, 2011 at 6:20 PM, Ding Dinghua <dingdinghua@nrchpc.ac.=
cn> wrote:
>> drop jh->b_jcount in error path
>> ---
>> =A0fs/jbd/transaction.c | =A0 =A02 +-
>> =A01 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
>> index 60d2319..3f7bf84 100644
>> --- a/fs/jbd/transaction.c
>> +++ b/fs/jbd/transaction.c
>> @@ -843,8 +843,8 @@ int journal_get_create_access(handle_t *handle, =
struct buffer_head *bh)
>> =A0 =A0 =A0 =A0 */
>> =A0 =A0 =A0 =A0JBUFFER_TRACE(jh, "cancelling revoke");
>> =A0 =A0 =A0 =A0journal_cancel_revoke(handle, jh);
>> - =A0 =A0 =A0 journal_put_journal_head(jh);
>> =A0out:
>> + =A0 =A0 =A0 journal_put_journal_head(jh);
>> =A0 =A0 =A0 =A0return err;
>> =A0}
>>
>> --
>> 1.7.4.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
