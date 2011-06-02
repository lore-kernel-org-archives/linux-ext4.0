From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] xfstests: add support for ext4dev FSTYP
Date: Thu, 02 Jun 2011 09:59:35 -0500
Message-ID: <4DE7A557.9040608@redhat.com>
References: <1306933012-8666-1-git-send-email-amir73il@users.sourceforge.net>	<20110601232804.GL32466@dastard>	<BANLkTi=sV5=PyZvNSd=DGNW-V84=27d7Yw@mail.gmail.com>	<BANLkTimbPWfOJKq6er4mnSYNPcx6VHLcrw@mail.gmail.com> <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	sergey57@gmail.com, Amir Goldstein <amir73il@users.sf.net>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <BANLkTimKV3LxugkW6_cE5vutjcmatESXuw@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 6/2/11 2:16 AM, Amir G. wrote:

> OK, after upgrading to newer util-linux and building it from git,
> which also didn't help, I finally found who to blame - me.
> I had an old (noauto) entry in /etc/fstab which claimed that /dev/sda5 is ext4.
> fsck was picking up that entry and insisting that /dev/sda5 is ext4
> (regardless of what it really is)
> blkid isn't doing that silly thing.
> 
> Amir

So where are we at with all this?

I don't really mind adding ext4dev to FSTYP case statements, it -is- something which blkid could, in theory, still return, and making xfstests cope with that and try to invoke fsck -t ext4dev doesn't bother me too much.  It is sadly an fs type embedded into a few tools.

But other than that, I don't think we should be making changes to upstream projects based on your current development hacks (I don't mean hack in a bad way, just that running sed across ext4 to create your custom filesystem for testing should not require upstream projects to change...)

So I'm ok with sprinkling "ext4|ext4dev" around if necessary.  Anyone else disagree?

-Eric
