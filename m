From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH V6 RESEND 01/15] ext4: add a function which extends a
 group without checking parameters
Date: Wed, 4 Jan 2012 11:59:24 +0800
Message-ID: <CAGBYx2aOsLTUvaytOxYt+XSJVpME_vgE+J8n4-LEAhYbfLdeJQ@mail.gmail.com>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
	<1325242812-27005-2-git-send-email-xiaoqiangnk@gmail.com>
	<20120103210748.GE30502@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:52918 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755446Ab2ADD7Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 22:59:25 -0500
Received: by obcwo16 with SMTP id wo16so13250758obc.19
        for <linux-ext4@vger.kernel.org>; Tue, 03 Jan 2012 19:59:25 -0800 (PST)
In-Reply-To: <20120103210748.GE30502@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 4, 2012 at 5:07 AM, Ted Ts'o <tytso@mit.edu> wrote:
> On Fri, Dec 30, 2011 at 06:59:58PM +0800, Yongqiang Yang wrote:
>> +static int ext4_group_extend_no_check(struct super_block *sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_fsblk_t o_blocks_coun=
t, ext4_grpblk_t add)
>
> I fixed the whitespace here (nit-picky, I know)
>
>> + =A0 =A0 handle =3D ext4_journal_start_sb(sb, 3);
>> + =A0 =A0 if (IS_ERR(handle)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 err =3D PTR_ERR(handle);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "error %d on journal star=
t", err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>
> There's only two calls "goto out", and out: currently is just "return
> err;". =A0So I just changed this to be "return err", which is clearer=
=2E
> I tend to place more imporance for clarity of the code than rigid
> rules which say that there should only be one control flow such that
> "return err" must only occur once at the end of the function.
>
>> + =A0 =A0 err =3D ext4_journal_get_write_access(handle, EXT4_SB(sb)-=
>s_sbh);
>> + =A0 =A0 if (err) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_warning(sb, "error %d on journal writ=
e access", err);
>> + =A0 =A0 =A0 =A0 =A0 =A0 ext4_journal_stop(handle);
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 }
>
> Instead of calling ext4_journal_stop() here, it's simpler just to jum=
p
> to the "exit_journal" label, which is consistent with what we do
> everywhere else. =A0Now all of the error gotos are to "exit_journal",
> which I've renamed to "errout".
>
> These are minor stylistic changes, but I thought I would mention them
> so that other people understand what is considered the best way to do
> things, I've just made these changes myself to avoid asking you to
> respin the patches.
Thanks!!!

Yongqiang.
>
> Regards,
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0- Ted



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
