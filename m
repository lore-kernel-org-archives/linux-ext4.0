From: "=?GBK?B?wfXhvyjOxMfkKQ==?=" <wenqing.lz@alibaba-inc.com>
Subject: Re: [PATCH v3 0/6] ext4: extents status tree shrinker improvement
Date: Tue, 21 Oct 2014 23:58:10 +0800
Message-ID: <007DCBDA-B924-4B45-887C-5FFFB8749966@alibaba-inc.com>
References: <1407382553-24256-1-git-send-email-wenqing.lz@taobao.com> <20141020144849.GB4499@thunk.org> <20141021102228.GC2955@quack.suse.cz>
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	"Zheng Liu" <gnehzuil.liu@gmail.com>, <linux-ext4@vger.kernel.org>,
	"=?GBK?B?wfXhvyjOxMfkKQ==?=" <wenqing.lz@taobao.com>,
	"Andreas Dilger" <adilger.kernel@dilger.ca>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out11.biz.mail.alibaba.com ([205.204.114.131]:35588 "EHLO
	out11.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755656AbaJUQPc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Oct 2014 12:15:32 -0400
In-Reply-To: <20141021102228.GC2955@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Jan and others,

I deeply sorry for this because of my delay work.  I don=E2=80=99t have=
 any objection
for Jan=E2=80=99s suggestions.  Until now there are still some works th=
at push me
tough, and I can see that I don=E2=80=99t have time to finish it at thi=
s merge
window.  It=E2=80=99s a shame for me!

Jan, I really really appreciate if you are willing to push this patch s=
et
to completion.  Thanks!!!

Regards,
						- Zheng

> On Oct 21, 2014, at 6:22 PM, Jan Kara <jack@suse.cz> wrote:
>=20
>  Hello,
>=20
> On Mon 20-10-14 10:48:49, Ted Tso wrote:
>> It's been a while since you've posted a revised version of this patc=
h
>> series.  I believe Jan had suggested some changes which you said you
>> would fix in the next set of patches.  Do you know when you might be
>> able that might be done?
>  Yeah, actually if you don't have time just say so. I can push it to
> completion somehow (there wasn't that much work left). I need the thi=
ng
> completed reasonably quickly since I already have some user reports f=
or
> openSUSE and I'm somewhat afraid reports for SLES will come pretty so=
on and
> I cannot leave those unresolved for long...
>=20
> 								Honza
> --=20
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
