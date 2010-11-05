From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1] fs: Small refactoring of the code in ext4
 2.6.37-rc1
Date: Fri, 5 Nov 2010 08:52:11 -0400
Message-ID: <20101105125211.GH7553@thunk.org>
References: <756314.4122.qm@web110514.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: =?iso-8859-1?Q?Andr=E9?= Luis Pereira dos Santos -
	 BSRSoft <andre@bsrsoft.com.br>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <756314.4122.qm@web110514.mail.gq1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 04, 2010 at 04:34:26PM -0700, Andr=E9 Luis Pereira dos Sant=
os - BSRSoft wrote:
>=20
> I had not realized that the side effect would really be changing
> variables incremented and decremented.

You're also wrong if you think that "i--" is more efficient than "i =3D
i - 1".  Any good compiler will do the right thing with either
expression.

       	    	     	       	    	      - Ted
