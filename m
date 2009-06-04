From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: Re: [PATCH 0/4] FS: userspace notification of errors
Date: Thu, 04 Jun 2009 09:10:59 +0300
Message-ID: <4A276573.5000900@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com> <20090603223005.GA9050@atrey.karlin.mff.cuni.cz>
Reply-To: Artem.Bityutskiy@nokia.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hirofumi@mail.parknet.co.jp" <hirofumi@mail.parknet.co.jp>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Hunter Adrian (Nokia-D/Helsinki)" <adrian.hunter@nokia.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090603223005.GA9050@atrey.karlin.mff.cuni.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

ext Jan Kara wrote:
>   Hi,
>=20
>> 2. Make FAT and EXT2 file systems use the above mechanism to optiona=
lly
>>    notify user space about errors. Implemented as 'notify' mount opt=
ion
>>    (PATCH 3,4).
>>    FAT error reporting facilities had to be re-factored (PATCH 2) in=
=20
>>    order to simplify sending error notifications.
>   One question: Why would not a filesystem / admin want the notificat=
ion
> to be sent? Or in other words what's the point of the mount option?

I agree on this. I guess we should instead implement a VFS helper
like 'send_error_notification(sb, error_type)'. Then we can teach
certain FSes to utilize it. We are particularly interested in FAT,
actually.

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
