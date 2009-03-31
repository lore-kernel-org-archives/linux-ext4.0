From: Fabio Comolli <fabio.comolli@gmail.com>
Subject: Re: Ext4 tree backports for 2.6.27.13 and 2.6.28.2
Date: Tue, 31 Mar 2009 14:02:26 +0200
Message-ID: <b637ec0b0903310502q56fc82eeobd5f62d24a367ac4@mail.gmail.com>
References: <E1LT8MN-0003Ps-Ur@closure.thunk.org>
	 <20090211075914.GC20842@skywalker>
	 <20090211153328.37ef255f@dhcp-100-2-144.bos.redhat.com>
	 <20090212211935.GE6922@mini-me.lan>
	 <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:8307 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZCaMC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 31 Mar 2009 08:02:29 -0400
In-Reply-To: <20090216163507.1e73f452@dhcp-100-2-144.bos.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Is there a patch for 2.6.27.X for people not using git?


On Mon, Feb 16, 2009 at 11:35 PM, Chuck Ebbert <cebbert@redhat.com> wro=
te:
> On Thu, 12 Feb 2009 16:19:35 -0500
> Theodore Tso <tytso@mit.edu> wrote:
>
>>
>> I've updated the for-stable and for-stable-2.6.27 branches against t=
he
>> latest stable releases, and I've updated the two flawed backports in
>> the for-stable-2.6.27 branch. =C2=A0Could you do a quick double-chec=
k and
>> make sure the fixes are as you expect, before I send a pull request =
to
>> stable@kernel.org?
>
> The 2.6.27 branch looks good to me.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
