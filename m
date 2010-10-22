From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v2 20/22] bitops: remove ext2 non-atomic bitops from asm/bitops.h
Date: Fri, 22 Oct 2010 16:56:58 +0900
Message-ID: <AANLkTi=DqhFAXx3yH_NkX=Rp1ntY8X-aUv4UG61QBfRQ@mail.gmail.com>
References: <1287672077-5797-1-git-send-email-akinobu.mita@gmail.com>
	<1287672077-5797-21-git-send-email-akinobu.mita@gmail.com>
	<AECEA79F-28E8-49B0-8C13-2CF115A6ECB4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <AECEA79F-28E8-49B0-8C13-2CF115A6ECB4@dilger.ca>
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2010/10/22 Andreas Dilger <adilger@dilger.ca>:
> On 2010-10-21, at 08:41, Akinobu Mita wrote:
>> As the result of conversions, there are no users of ext2 non-atomic =
bit
>> operations except for ext2 file system itself. =A0Now we can put the=
m
>> into architecture independent code in ext2 file system, and remove
>> from asm/bitops.h for all architectures.
>
> Presumably there will be a separate patch series to remove the atomic=
 ext2 bitops? =A0I was going to suggest removing the ext2 comment in bi=
tops.h, but I notice that there are still the atomic bitops left.

I wanted to remove them altogether, but it turns out that I need
more consideration (what is the better name? where should they move to?=
)
and I have already touched more files than I expected in this patch ser=
ies.
So I decided to make it a pending question.
