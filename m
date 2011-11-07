From: NamJae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH v2] ext4: fix NULL pointer dereference from orig_data in
 fill_super and remount.
Date: Tue, 8 Nov 2011 08:42:53 +0900
Message-ID: <CAKYAXd9qWfLntfuUnhZdEsL2u428=GZ=DDu2V9S518YjKXEFMw@mail.gmail.com>
References: <1320674511-1980-1-git-send-email-linkinjeon@gmail.com>
	<20111107151939.GA24234@thunk.org>
	<CAKYAXd_u813Q0k1iMMnfwORxXYDEBtpaKMig1FGBOKpNW3s3rg@mail.gmail.com>
	<E08B31F5-C43D-4145-BC38-C1C967CDD18E@MIT.EDU>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64997 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab1KGXmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 18:42:55 -0500
In-Reply-To: <E08B31F5-C43D-4145-BC38-C1C967CDD18E@MIT.EDU>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2011/11/8 Theodore Tso <tytso@mit.edu>:
>
> On Nov 7, 2011, at 6:06 PM, NamJae Jeon wrote:
>
>> =C2=A0if(data) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0orig_data =3D=
 kstrdup(data, GFP_KERNEL);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if(!orig_data=
)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0return ret;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0}
>
> As I said earlier, the use of kstrdup() in the ext4 mount code is so =
that we can print the mount options used in the mount request. =C2=A0 S=
o if the kstrdup() fails, the worst that will happen is that the printk=
 will print the the mount had no mount options, instead of the mount op=
tions which had been passed this might be misleading, but it's not the =
end of the world; it's only a cosmetic issue. =C2=A0But if the kstrdup(=
) failed, the other memory allocations (that in general will be for muc=
h more memory) will also fail, so the mount will return ENOMEM before e=
ver getting to the printjk. =C2=A0 So a pendant might make the above ch=
ange, but in practice it's not really that important to do that particu=
lar checking in this case.
>
> This is why it's important to really understand the code in question =
instead of just posting patches without understanding the underlying co=
de, and understanding what might or might not go wrong both before appl=
ying the patch, and after applying the patch. =C2=A0 And of course, tes=
ting all of the use cases is also really important.
Okay, I understand clearly.
Thanks.
>
> Best regards,
>
> -- Ted
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
