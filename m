From: Matt <jackdachef@gmail.com>
Subject: Re: hunt for 2.6.37 dm-crypt+ext4 corruption? (was: Re: dm-crypt
 barrier support is effective)
Date: Wed, 15 Dec 2010 20:28:03 +0100
Message-ID: <AANLkTimjnfAQv5J5LRsgtKBb5Ho=M2ZJ=qvDHnkpBwN4@mail.gmail.com>
References: <AANLkTinMt6saGeeX3MbwAzZ-+f6AL5BegeFqyPgGwiDo@mail.gmail.com>
	<AANLkTi=cn04WZGMnVX6ie5PSM+9v0tJSSg0kD8_W5N11@mail.gmail.com>
	<20101212023415.GG3059@thunk.org>
	<AANLkTim=i8wDnML+K4uGK_neNDCiWxtKGDx01O+3joaE@mail.gmail.com>
	<AANLkTinhHTqqpP=pQ8Foyc9xeaZi65GHGHGY51OyZtvF@mail.gmail.com>
	<20101212124354.GA4513@thunk.org>
	<AANLkTikZkCs7Wee2=uhe3bw96Pggcv0jsCkZ+nkWEQ+=@mail.gmail.com>
	<20101213020657.GB4513@thunk.org>
	<AANLkTinMWS-yyzWJ3oBo_KS9jXt4p4pveo+SPTLiWnCt@mail.gmail.com>
	<AANLkTimjM_HptLaCSuQivxruWpoc7todyMe0wnszrSYU@mail.gmail.com>
	<20101215191655.GA6163@basil.fritz.box>
	<AANLkTi=9fbou9YF2bXzrWbBM37F4_Xyi-KgWquq0PrBL@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jon Nelson <jnelson@jamponi.net>,
	Chris Mason <chris.mason@oracle.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mike Snitzer <snitzer@redhat.com>,
	Milan Broz <mbroz@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>, htejun <htejun@gmail.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=9fbou9YF2bXzrWbBM37F4_Xyi-KgWquq0PrBL@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 15, 2010 at 8:25 PM, Matt <jackdachef@gmail.com> wrote:
> On Wed, Dec 15, 2010 at 8:16 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> I have a question though: the deactivation of multiple page-io
>>> submission support most likely only would affect bigger systems or
>>> also desktop systems (like mine) ?
>>
>> I think this is not a final fix, just a workaround.
>> The problem with the other path still really needs to be tracked down.
>>
>> -Andi
>>
>> --
>> ak@linux.intel.com -- Speaking for myself only.
>>
>
> ok,
>
> thanks for the clarification
>
> Regards
>
> Matt
>

Sorry to spam the mailing lists again

make that a
Reported-and-Tested-by: Matthias Bayer <jackdachef@gmail.com>

(hope that's the correct way to write it)

Regards

Matt
