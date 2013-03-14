From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: NULL pointer dereference in ext4_superblock_csum_set with
 mounted filesystem
Date: Thu, 14 Mar 2013 00:08:35 -0400
Message-ID: <20130314040835.GB11821@thunk.org>
References: <20130313185911.GA1446@jtriplet-mobl1>
 <20130313190141.GF5604@thunk.org>
 <20130313191016.GA1793@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: Josh Triplett <josh@joshtriplett.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130313191016.GA1793@jtriplet-mobl1>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Huh.  This is very, very weird.  Is this a repeatable crash?

      	      	    	 	    	 - Ted
