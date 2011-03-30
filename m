From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [LSF/FS TOPIC] Ext4 snapshots status update
Date: Wed, 30 Mar 2011 12:46:24 +0200
Message-ID: <AANLkTikPzr-RTLcnxWm+qqRNTmBP6DkYRV=KJtkY7zG-@mail.gmail.com>
References: <AANLkTink6o249JivXiETT6JnANNcikNqGGfr8+McDQsM@mail.gmail.com>
	<20110204002043.GA15658@noexit>
	<AANLkTimuR-oOprBR7Xkehx01ojrdxYOmgqdnX7wNbpt6@mail.gmail.com>
	<20110330003429.GA32669@noexit>
	<AANLkTi=vReDmq22=kKieJp9uaeAVC-VXj8VjHWQfXaDp@mail.gmail.com>
	<4D92C508.7010404@tao.ma>
	<AANLkTinV-WSj2c+dtNyaS-r8xf_c0R5UB-_f73XLm0Z8@mail.gmail.com>
	<20110330103321.GB1564@noexit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Tao Ma <tm@tao.ma>, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Joel Becker <jlbec@evilplan.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110330103321.GB1564@noexit>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Mar 30, 2011 at 12:33 PM, Joel Becker <jlbec@evilplan.org> wrot=
e:
> On Wed, Mar 30, 2011 at 08:05:38AM +0200, Amir Goldstein wrote:
>> Just wanted to clarify there are 2 differences I notice between mmap
>> write to a hole
>> and mmap write to COWed file with ENOSPC:
>>
>> 1. A "good" application can avoid mmap write to a hole.
>>
>> 2. when initiating a hole, the mkwrite callback is in used (in ext4)=
 to
>> reserve disk space for delayed allocation when a page becomes writab=
le.
>> with COW a page may already be writable when the flush encounters CO=
W
>> with ENOSPC. that flush can even happen after the application has ex=
ited,
>> so the data will be dropped on the floor silently (like in ext3).
>
> =A0 =A0 =A0 =A0ocfs2 doesn't have delayed allocation yet, so we try a=
nd fail
> the allocation in write_begin() right under mkwrite().
>

And what if the page is already writable?
Do you go over all inode pages and make them RO after fastcopy?
=46or volume level snapshot this isn't a sensible option.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
