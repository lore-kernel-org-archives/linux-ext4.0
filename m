From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
Subject: Re: Zero length files - an alternative approach?
Date: Sun, 29 Mar 2009 14:02:50 +0200
Message-ID: <49CF636A.3030400@ursus.ath.cx>
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755830AbZC2MDQ@vger.kernel.org>
In-Reply-To: <yw1xab744lqi.fsf@thrashbarg.mansr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



On 29.03.2009 13:22 M=E5ns Rullg=E5rd wrote:
> Consider this scenario:
>
> 1. Create/write/close newfile
> 2. Rename newfile to oldfile
> 3. Open/read oldfile.  This must return the new contents.
> 4. System crash and reboot before delayed allocation/flush complete
> 5. Open/read oldfile.  Old contents now returned.
>
> This rollback isn't obviously, to me at least, without problems of it=
s
> own.
>
>  =20
Having the old data in 5) is far better than having no data in 5).
