From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove abnormal set for I_DATA_SEM subclass
Date: Mon, 23 Jul 2018 12:23:38 -0400
Message-ID: <20180723162338.GG3358@thunk.org>
References: <1531123108-45918-1-git-send-email-junil0814.lee@lge.com>
 <20180722220841.GA3358@thunk.org>
 <ccb7943b-44af-5031-8410-f1c0851e70c2@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, junil0814.lee@MIT.EDU
To: =?utf-8?B?7J207KSA7J28L+yXsOq1rOybkC9NQ+yXsOq1rOyGjCBCU1Dsi6QgQlNQNg==?=
         =?utf-8?B?7YyAKGp1bmlsMDgxNC5sZWVAbGdlLmNvbSk=?=
        <junil0814.lee@lge.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ccb7943b-44af-5031-8410-f1c0851e70c2@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 23, 2018 at 10:48:37AM +0900, 이준일/연구원/MC연구소 BSP실 BSP6팀(junil0814.lee@lge.com) wrote:
> Then, I have a question.
> quotactl() doesn't have case only to set limits flag, the routine to set
> the DQUOT_LIMITS_ENABLED flag is under dquot_enable() function.
> According to this logic, if users makes duplicate request to set
> DQUOT_LIMITS_ENABLED flags, can lockdep make the false alarm with ext4 ?

With the upstream kernel, if you call quotactl with the Q_QUOTAON
command, it will fail with EEXIST before it ever gets to the file
system specific quota code.  This happens in dquot_quota_enable() in
fs/quota/dquot.c.

I'm going to guess you didn't try to reproduce the problem with the
latest mainstream kernel, and then applied the patch, and verified the
problem went away before you submitted it?

Regards,

					- Ted
