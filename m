From: Kyungmin Park <kmpark@infradead.org>
Subject: Re: Is it possible for the ext4/btrfs file system to pass some
 context related info to low level block driver?
Date: Tue, 3 May 2011 13:10:26 +0900
Message-ID: <BANLkTikm-ZMG7KRjjz0DtduPDC4KUw7_Bg@mail.gmail.com>
References: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A47358E28022@shsmsx501.ccr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

It seems similar with TRIM. So how about to consider TRIM
implementation or extend it?
I'm not familiar with NCQ implementation but it's also helpful to imple=
ment it.

Thank you,
Kyungmin Park

On Tue, May 3, 2011 at 11:44 AM, Gao, Yunpeng <yunpeng.gao@intel.com> w=
rote:
> Currently, some new storage devices have the ability to do performanc=
e optimizations according to the type of data payload - say, file syste=
m metadata, time-stamps, sequential write in some granularity, random w=
rite and so on.
>
> For example, the latest eMMC 4.5 device can support the so-called 'Co=
ntext Management' and 'Data Tag Mechanism' features. By receiving the i=
nformation of payload data type, the eMMC 4.5 device can improve the ac=
cess rate during the following read and update operations and offer a m=
ore reliable and robust storage.
>
> And obviously, to enable these kind of advanced features of storage d=
evice, it needs not only the low level block device driver supports, bu=
t also the file system supports since files system knows more info abou=
t the data type of the payload. But currently, seems there are no file =
systems implemented these kind of supports yet.
>
> So, my question is, is there any plan or discussion on supporting thi=
s feature (passing data type info to low level block device driver) on =
file system developments? Especially for ext4/btrfs, since now they are=
 very hot in Linux? Thanks.
>
>
> Regards,
> Yunpeng Gao
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
