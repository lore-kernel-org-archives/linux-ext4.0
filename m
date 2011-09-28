From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: Add SEEK_DATA/SEEK_HOLE support V2
Date: Wed, 28 Sep 2011 15:21:08 +0800
Message-ID: <CAGBYx2YzeBvQPEV7uuHmxwZQD+oE+nuF_bd+CZwzm1F0n8o-ZA@mail.gmail.com>
References: <4E82BF7B.7000403@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Sunil Mushran <sunil.mushran@oracle.com>
To: jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47585 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1I1HVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 28 Sep 2011 03:21:11 -0400
Received: by gyg10 with SMTP id 10so5982686gyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 00:21:10 -0700 (PDT)
In-Reply-To: <4E82BF7B.7000403@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 28, 2011 at 2:32 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
> Hello all,
>
> This is the V2 for add SEEK_DATA/SEEK_HOLE support to ext4.
> In V1, I copied all the codes regarding fetching delayed-extents out =
to
> my seek callback function, it's stupid to duplicate the code blocks.
>
> Now the idea is, since the delayed-extents is the main concern to sea=
rch
> extents for both fiemap and seek, so IMHO, it's better to consolidate
> this procedure into a new function(get_delayed_extent() in my patch),
> and call it in fiemap and seek call-back functions if necessary. =A0I=
n
> this way, when yongqiang's delayed-extents tree is ready, we only nee=
d
> to modify the code block at get_delayed_extent() accordingly.
>
> In addition, yongqiang has pointed out there might be a deadlock, but
> per my understood, as the target inode already locked via i_mutex in
> ext4_llseek() before, this lock can prevent any modification to the
> file, and we call find_get_pages_tag() when trying to fetch the dirty
> pages, this function using rcu read lock, it also safe to read. =A0So=
 I
> have no idea what's wrong, could anyone please kindly point me out in
> this case? =A0I'm definitely a newbie to this list, sorry for my igno=
rant.
Ok.  There is no deadlock, fiemap releases i_data_sem before calling
get_delayed_extent().

BTW: It seems that there is a bug in fiemap according to code, I am
not sure which commit introduced it, delayed extents beyond last
allocated block are ignored.

Yongqiang.
>
> Anyway, I'd like to post the revised for your guys review first.
> In have split the modification to two patches this time, since I hope=
 to
> make it looks more convenient for the review purpose.
>
> The 1st patch, remove the delayed-extents fetching procedure to a
> function named as get_delayed_extent(), and modify the
> ext4_ext_fiemap_cb() accordingly.
>
> The 2nd path add the ext4_ext_seek_cb() to implement the
> SEEK_HOLE/SEEK_DATA stuff based on previous code change.
>
> Testing:
> =3D=3D=3D=3D=3D=3D=3D=3D
> In addition to the test cases mentioned in V1, I also done another te=
sts
> through sunil's seek test program, please refer to:
> http://oss.oracle.com/~smushran/seek_data/seek_test.c
>
> To ensure the 1st patch does not cause regression issue on fiemap, I
> have done some tests via cp(1) with fiemap copy support, the sparse f=
ile
> used for this test is produced by:
> python -c "f=3Dopen('./sptest', 'w'); [(f.seek(x) or f.write(str(x)))=
 for
> x in range(1, 1000000000, 99999)]; f.close()
>
>
> Any feedback are appreciated!
>
>
> Thanks,
> -Jeff
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
