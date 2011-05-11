From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH 0/3] Rewrite ext4_page_mkwrite, fix fs freezing
Date: Wed, 11 May 2011 13:15:36 +0300
Message-ID: <BANLkTik7pmNpiWR4jZAZALf58S+015dYAw@mail.gmail.com>
References: <1305066574-1573-1-git-send-email-jack@suse.cz>
	<BANLkTinLxrarrb0W2eA-=ZM=2LbA33qiZA@mail.gmail.com>
	<20110511094311.GB5057@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110511094311.GB5057@quack.suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, May 11, 2011 at 12:43 PM, Jan Kara <jack@suse.cz> wrote:
> =A0Hi Amir,
>
> On Wed 11-05-11 10:33:17, Amir G. wrote:
>> Can you provide a bit of a wider scope review of how this related to=
 the
>> work on stable pages.
> =A0It is related in the sense that Darrick had to return locked page =
from
> ext4_page_mkwrite() to avoid races and the result (although working) =
is
> really like scratching your left ear with your right hand (not sure i=
f
> English has this idiom ;). So with my patches, what Darrick needs to =
do is
> simply achieved by updating block_page_mkwrite() (__block_page_mkwrit=
e() in
> fact).
>
>> For example, when to the pages get unlocked?
> =A0That's handled by mm code in mm/memory.c. You can read do_wp_page(=
) but
> it's not a light reading ;)

This is why I asked for the cheat sheet ;-)

>
>> If the pages supposed to be stable during writeback, how is this rel=
ated
>> to returning locked pages from page_mkwrite?
> =A0Returning locked page is needed to avoid races with page writeback=
 - for
> stable pages we want to do wait_on_page_writeback() to be sure that t=
here's
> no IO happening while we make the page writeable for user. But once w=
e
> release page lock, writepage can come and start the writeback. The ba=
sic
> scheme of the race we want to avoid is:
> =A0do_wp_page()
> =A0 =A0ext4_page_mkwrite()
> =A0 =A0 =A0wait_on_page_writeback()
> =A0 =A0 =A0unlock_page()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0clear_page_dirty_for_io()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0page_mkclean()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0writepage()
> =A0 =A0maybe_mkwrite()
>
> Because this results in writeable page under writeback... We have to =
make
> sure page_mkclean() happens *after* maybe_mkwrite() from do_wp_page()=
 in
> this scenario.
>
>> Is the page going to stay locked until writeback?
> =A0No, until the page fault is finished.
>
>> Do I understand correctly that a page will be marked read-only after
>> writeback completes, so page_mkwrite will be called again on next wr=
ite?
> =A0Page is marked read-only before writeback is started in
> clear_page_dirty_for_io().

OK. that makes sense. I wasn't sure my move-on-write hook,
which is called from ext4_page_mkwrite() is going to be called on every
writeback.
The use case is:
data =3D mmap(file);
data[0] =3D 1;
take snapshot 1;
data[0] =3D 2;
take snapshot 2;
data[0] =3D 3;
=2E..

That use case doesn't specify when writeback of first page of file happ=
ens
and I don't care which version of data[0] is seen by the snapshots, as =
long
as the snapshot view is internally consistent (it doesn't change over t=
ime or
after reboot).

So if ext4_page_mkwrite() is called after every writeback and the page =
is stable
during writeback, snapshots should be OK.

>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
