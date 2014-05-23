From: Niu Yawei <yawei.niu@gmail.com>
Subject: Re: [PATCH] quota: remove dqptr_sem for scalability
Date: Fri, 23 May 2014 13:22:13 +0800
Message-ID: <537EDB05.8030109@gmail.com>
References: <537DD5BA.1050105@gmail.com> <537EC854.1060605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: yawei.niu@intel.com, andreas.dilger@intel.com, jack@suse.cz,
	lai.siyao@intel.com
To: Eric Sandeen <sandeen@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <537EC854.1060605@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

=D3=DA 2014/5/23 12:02, Eric Sandeen =D0=B4=B5=C0:
> On 5/22/14, 5:47 AM, Niu Yawei wrote:
>> There are several global locks in the VFS quota code which hurts
>> performance a lot when quota accounting enabled, dqptr_sem is the ma=
jor one.
>>
>> This patch tries to make the VFS quota code scalable with minimal ch=
anges.
>>
>> Following tests (mdtest & dbench) were running over ext4 fs in a
>> centos6.5 vm (8 cpus, 4G mem, kenrel: 3.15.0-rc5+), and the result s=
hows
>> the patch relieved the lock congestion a lot.
>>
> Just noticed this patch - FWIW, Lustre has a=20
> "quota-replace-dqptr-sem-sles11sp2.patch" that they apply:
Yes, I'm Lustre developer and trying to push the patch upstream. :)
>
> http://git.whamcloud.com/?p=3Dfs/lustre-release.git;a=3Dblob;f=3Dlust=
re/kernel_patches/patches/quota-replace-dqptr-sem-sles11sp2.patch;h=3Dc=
880dac83473f48cac96dc467ea76f64a74fe5dd;hb=3DHEAD
>
> which might be interesting if you're looking at this.
>
> (Or maybe it's doing the same thing; TBH I have not looked at
> either patch, I just remembered that it existed...)
>
> -eric

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
