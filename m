From: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: [PATCH, v2] ext3: validate directory entry data before use
Date: Sat, 21 Jun 2008 17:31:41 +0100
Message-ID: <e9e943910806210931s77dd4679m5a30561e01bcd207@mail.gmail.com>
References: <1214013261-32428-1-git-send-email-duaneg@dghda.com>
	 <1214063696-16546-1-git-send-email-duaneg@dghda.com>
	 <ef1cd66f0806210913p59d73cd6he86b656682ad67e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	"Sami Liedes" <sliedes@cc.hut.fi>
To: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.174]:61484 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYFUQbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 21 Jun 2008 12:31:44 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1378221wfd.4
        for <linux-ext4@vger.kernel.org>; Sat, 21 Jun 2008 09:31:41 -0700 (PDT)
In-Reply-To: <ef1cd66f0806210913p59d73cd6he86b656682ad67e9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2008/6/21 Jochen Vo=DF <jochen.voss@googlemail.com>:
> Hi Duane,
>
> 2008/6/21 Duane Griffin <duaneg@dghda.com>:
>> @@ -1397,8 +1434,15 @@ static int make_indexed_dir(handle_t *handle,=
 struct dentry *dentry,
>>        memcpy (data1, de, len);
>>        de =3D (struct ext3_dir_entry_2 *) data1;
>>        top =3D data1 + len;
>> -       while ((char *)(de2 =3D ext3_next_entry(de)) < top)
>> +
>> +       while (1) {
>> +               de2 =3D ext3_next_entry("make_indexed_dir", dir, de,=
 bh, 0);
>> +               if (de2 =3D=3D NULL || (char *) (char *) (char *) (c=
har *) (char *) (char *) (char *) (char *) (char *) de2 >=3D top) {
>
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This looks very strange!

Aargh, I just can't seem to get this patch out cleanly! That looks
like a vi typo, thanks for catching it so quickly. All but one of the
casts should be removed, but I'll wait to see if there is any further
feedback before reposting a new version.

> All the best,
> Jochen

Cheers,
Duane.

--=20
"I never could learn to drink that blood and call it wine" - Bob Dylan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
