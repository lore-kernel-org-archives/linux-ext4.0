From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: only call ext4_jbd2_file_inode when an inode has
 been extended
Date: Thu, 15 Sep 2011 10:44:45 +0800
Message-ID: <CAGBYx2YQM-GhPcXLUAMKds31u-zmp77eKoHodSPK6LOms1sZyA@mail.gmail.com>
References: <1315291106-25551-1-git-send-email-tytso@mit.edu>
	<20110906100253.GB23747@quack.suse.cz>
	<20110906153601.GA20571@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Allison Henderson <achender@linux.vnet.ibm.com>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f170.google.com ([209.85.161.170]:54815 "EHLO
	mail-gx0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1IOCoq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 14 Sep 2011 22:44:46 -0400
Received: by gxk27 with SMTP id 27so2996244gxk.1
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 19:44:45 -0700 (PDT)
In-Reply-To: <20110906153601.GA20571@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 6, 2011 at 11:36 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Tue, Sep 06, 2011 at 12:02:53PM +0200, Jan Kara wrote:
>> =A0 Umm, I don't quite understand the race. It seems to me we can bl=
ock on
>> lack of journal space during writeback only in ext4_da_writepages() =
where
>> we do ext4_journal_start(). But at that point there shouldn't be any=
 pages
>> with PageWriteback set which were not submitted for IO. So it's not =
clear
>> to me why PageWriteback bit does not get cleared when IO finishes an=
d
>> kjournald would then continue. Is it because IO completion is someho=
w
>> blocked on journal?
>
> No, you're right. =A0I looked more closely at it and the problem is
> because of the end_io handling. =A0There was a thead blocked in
> mpage_da_map_and_submit path but it was blocked in
> ext4_get_wite_access(), and it was not holding PageWriteback at the
> time.
>
>> That would seem possible as I'm looking e.g. into
>> ext4_convert_unwritten_extents(). But then any waiting for writeback=
 from
>> kjournald is prone to deadlocks. In fact regardless of what kjournal=
d does
>> there does not seem to be sane lock ordering since we have:
>>
>> transaction start -> PageWriteback -> transaction start
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ^ =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
^
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 =A0 =A0 =A0 end_io handlin=
g if I'm right
>> =A0 =A0 =A0 enforced by write_cache_pages_da
>>
>> =A0 Which is really nasty. We cannot end page writeback until the pa=
ge is
>> readable from disk which means until we have properly updated extent=
 tree.
>> But for extent tree update we need a transaction. The only way out I=
 can
>> see is to reserve space for extent tree update in a transaction in
>> writepages() and holding the transaction open until end_io time when=
 we
>> change extent tree and close the transaction. But I'm afraid that's =
going
>> to suck under heavy load...
>
> Yes, that's a problem with ext4_convert_unwritten_extents() being
> called out of end_io handling, and of course dioread_nolock does a lo=
t
> more of that, hence why it shows up in that mode.
>
> I think the long-term solution here is that we have to reserve space
> and make the allocation decision at writepages() time, but we don't
> actually modify any on-disk state, hence we don't have to hold a
> transaction open. =A0We just prevent those disk blocks from getting
> allocated anywhere else, and we tentative assoicate physical blocks
> with the logical block numbers, but in a memory structure only. =A0Th=
en
> when the pages are written, we can drop PageWriteback. =A0We don't ha=
ve
> to wait until the extent blocks are written to disk, so long as any
> callers of ext4_map_blocks() get the right information (via an
> in-memory cache that we would have to add to make this whole thing
> first), and so long as fsync() not only calls filemap_fdatawrite(),
> but also waits for the metadata updates to the extent tree/indirect
> blocks have been completed.
Hi Ted,

It seems that this can be implemented on delayed extent tree(RB tree)
easily, we just allocate blocks from buddy allocator and associate
them to logical blocks with delayed extent.  fsync inserts delayed
extents into extent tree.

BTW: I have sent out patch series implementing delayed extent list,
which will use RB tree later.  The patch series pass all xfstests
except 74, there was a deadlock there, I could not find it out.

What's your opinion?

Yongqiang.
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
