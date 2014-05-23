From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] quota: remove dqptr_sem for scalability
Date: Fri, 23 May 2014 08:02:37 -0500
Message-ID: <537F46ED.3050505@redhat.com>
References: <537DD5BA.1050105@gmail.com> <537EC854.1060605@redhat.com> <537EDB05.8030109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: Niu Yawei <yawei.niu@gmail.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <537EDB05.8030109@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 5/23/14, 12:22 AM, Niu Yawei wrote:
> =D3=DA 2014/5/23 12:02, Eric Sandeen =D0=B4=B5=C0:
>> On 5/22/14, 5:47 AM, Niu Yawei wrote:
>>> There are several global locks in the VFS quota code which hurts
>>> performance a lot when quota accounting enabled, dqptr_sem is the m=
ajor one.
>>>
>>> This patch tries to make the VFS quota code scalable with minimal c=
hanges.
>>>
>>> Following tests (mdtest & dbench) were running over ext4 fs in a
>>> centos6.5 vm (8 cpus, 4G mem, kenrel: 3.15.0-rc5+), and the result =
shows
>>> the patch relieved the lock congestion a lot.
>>>
>> Just noticed this patch - FWIW, Lustre has a=20
>> "quota-replace-dqptr-sem-sles11sp2.patch" that they apply:
> Yes, I'm Lustre developer and trying to push the patch upstream. :)

I'm sorry.  I took a quick glance at both and somehow didn't realize th=
ey
were the same.  That's what I get for sending emails too late at night.

Sorry for the noise!  Carry on... ;)  And thanks for doing this!

-Eric

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
