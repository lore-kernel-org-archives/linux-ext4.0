From: Richard Weinberger <richard@nod.at>
Subject: Re: vmalloc with GFP_NOFS
Date: Tue, 24 Apr 2018 21:05:05 +0200
Message-ID: <1715857.C3bTW05DZe@blindfold>
References: <20180424162712.GL17484@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="nextPart1929745.k0RrSNZNOz"
Content-Transfer-Encoding: 7Bit
Cc: Kate Stewart <kstewart@linuxfoundation.org>,
	Trond Myklebust <trond.myklebust@primarydata.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	cluster-devel@redhat.com, Marek Vasut <marek.vasut@gmail.com>,
	linux-ext4@vger.kernel.org, Cyrille Pitchen <cyrille.pitchen@wedev4u.fr>,
	Mikulas Patocka <mpatocka@redhat.com>, linux-nfs@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>, Artem Bityutskiy <dedekind1@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Philippe Ombredanne <pombredanne@nexb.com>, linux-mtd@lists.infradead.org,
	Brian Norris <computersforpeace@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Anna Schumaker <anna.schumaker@netapp.com>
To: Michal Hocko <mhocko@kernel.org>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180424162712.GL17484@dhcp22.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.

--nextPart1929745.k0RrSNZNOz
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Dienstag, 24. April 2018, 18:27:12 CEST schrieb Michal Hocko:
> Hi,
> it seems that we still have few vmalloc users who perform GFP_NOFS
> allocation:
> drivers/mtd/ubi/io.c

UBI is also not a big deal. We use it here like in UBIFS for debugging
when self-checks are enabled.

Thanks,
//richard

--nextPart1929745.k0RrSNZNOz
Content-Transfer-Encoding: 7Bit
Content-Type: text/html; charset="us-ascii"

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN" "http://www.w3.org/TR/REC-html40/strict.dtd">
<html><head><meta name="qrichtext" content="1" /><style type="text/css">
p, li { white-space: pre-wrap; }
</style></head><body style=" font-family:'Hack'; font-size:10pt; font-weight:400; font-style:normal;">
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Am Dienstag, 24. April 2018, 18:27:12 CEST schrieb Michal Hocko:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; Hi,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; it seems that we still have few vmalloc users who perform GFP_NOFS</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; allocation:</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">&gt; drivers/mtd/ubi/io.c</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">UBI is also not a big deal. We use it here like in UBIFS for debugging</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">when self-checks are enabled.</p>
<p style="-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; ">&nbsp;</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">Thanks,</p>
<p style=" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px; -qt-user-state:0;">//richard</p></body></html>
--nextPart1929745.k0RrSNZNOz--
