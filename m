From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data in
 fill_super and remount.
Date: Tue, 8 Nov 2011 08:06:43 +0900
Message-ID: <CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
	<20111107151939.GA24234@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56849 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab1KGXGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 18:06:44 -0500
In-Reply-To: <20111107151939.GA24234@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/8 Ted Ts'o <tytso@mit.edu>:
> On Mon, Nov 07, 2011 at 11:01:51PM +0900, Namjae Jeon wrote:
>> Fix NULL pointer dereference from orig_data in fill_super and remoun=
t.
>>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>
> Um, did you even try to test this patch before submitting it?
>
> #1: =C2=A0 kstrdup() return NULL if data is NULL
>
> #2: =C2=A0The kernel's printk and sprintf functions will translate
> =C2=A0 =C2=A0 sprintf(buf, "%s", NULL) by filling in the string "NULL=
"
>
> #3: =C2=A0The only use of orig_data is a cosmetic one, of printing ou=
t
> =C2=A0 =C2=A0 the mount options which are passed in.
>
> #4: =C2=A0If the user doesn't specify any mount options, data is NULL=
, and
> =C2=A0 =C2=A0 your patch would cause those mounts to fail with ENOMEM=
=2E
>
> In summary, there is no problem here; a pendant might complain that
> it's possible for data to be non-NULL, and for orig_data to be null o=
f
> the kstrdup failed, but in that case, other memory allocations done
> later in ext4_fill_super() will almost have certainly failed, so in
> practice won't get as far as the printk.
Hi. Ted.
Sorry, I will make a patch next time after testing. Thanks for your rev=
iew.
And I checked how to handle this case in other filesystem.

btrfs try to handle like this.
-----------------------------------------------------------------------=
-------
	if (!options)
		goto out;

	/*
	 * strsep changes the string, duplicate it because parse_options
	 * gets called twice
	 */
	opts =3D kstrdup(options, GFP_KERNEL);
	if (!opts)
		return -ENOMEM;
-----------------------------------------------------------------------=
--------

So I suggest that ext4 try to handle like this.
-----------------------------------------------------------------------=
--------
        if(data) {
                orig_data =3D kstrdup(data, GFP_KERNEL);
                if(!orig_data)
                        return ret;
        }
-----------------------------------------------------------------------=
--------
I want to know your opinion.
Thanks.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0-=
 Ted
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
